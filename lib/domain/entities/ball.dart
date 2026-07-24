import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../../presentation/game/ball_prototype.dart';
import 'spike.dart';
import 'goal.dart';

/// Uma bola física controlada pela inclinação do dispositivo e reiniciada ao bater em espinhos.
class Ball extends BodyComponent<BallPrototype> with ContactCallbacks {
  /// A posição de spawn usada para reiniciar a bola após colisão.
  final Vector2 initialPosition;

  bool _shouldReset = false;

  // 0.0 = transparente, 1.0 = opaco (para o caso de não teres sprite ainda)
  double opacity = 1.0;

  Ball([Vector2? initialPosition])
      : initialPosition = initialPosition ?? Vector2(5.0, 50.0) {
    priority = 10; // Garante que a bola é desenhada por cima do mapa
  }

  @override
  void render(Canvas canvas) {
    if (opacity > 0) {
      final paint = Paint()..color = const Color(0xFFFFFFFF).withOpacity(opacity);
      canvas.drawCircle(Offset.zero, 1.0, paint); // 1.0 é o raio definido no createBody
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: initialPosition,
      linearDamping: 0.5,
      angularDamping: 0.5,
      allowSleep: false,
    );

    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = 1;

    final fixtureDef = FixtureDef(
      shape,
      density: 1.0,
      friction: 0.2,
      restitution: 0.3,
      userData: this,
    );

    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_shouldReset) {
      _doReset();
      _shouldReset = false;
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    // Reinicia a bola quando toca num espinho.
    if (other is Spike) {
      reset();
    } else if (other is Goal) {
      // Usamos a referência ao jogo para disparar a vitória
      game.onGoalReached();
    }
  }

  // Marca a bola para ser reiniciada.
  void reset() {
    _shouldReset = true;
  }

  // Reposiciona a bola no ponto inicial.
  void _doReset() {
    body.setTransform(initialPosition, 0.0);
    body.linearVelocity = Vector2.zero();
    body.angularVelocity = 0;
  }
}