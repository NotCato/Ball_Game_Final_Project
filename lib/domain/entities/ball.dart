import 'package:flame_forge2d/flame_forge2d.dart';

import '../../presentation/game/ball_prototype.dart';
import 'goal.dart';
import 'spike.dart';

/// Uma bola física controlada pela inclinação do dispositivo e reiniciada ao bater em espinhos.
class Ball extends BodyComponent<BallPrototype> with ContactCallbacks {
  /// A posição de spawn usada para reiniciar a bola após colisão.
  final Vector2 initialPosition;
  bool _shouldReset = false;

  Ball([Vector2? initialPosition])
      : initialPosition = initialPosition ?? Vector2(5.0, 50.0) {
    debugMode = true;
    priority = 10;
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

    print("BALL CONTACT -> ${other.runtimeType}");

    if (other is Spike) {
      print("SPIKE DETECTED");
      reset();
    } else if (other is Goal) {
      print("GOAL DETECTED");
      game.onGoalReached();
    }
  }

  /// Marca a bola para ser reiniciada fora do passo de física.
  void reset() => _shouldReset = true;

  void _doReset() {
    body.setTransform(initialPosition, 0.0);
    body.linearVelocity = Vector2.zero();
    body.angularVelocity = 0;
  }
}