import 'package:flame_forge2d/flame_forge2d.dart';
import 'spike.dart';
import 'goal.dart';

/// Uma bola física controlada pela inclinação do dispositivo e reiniciada ao bater em espinhos.
class Ball extends BodyComponent with ContactCallbacks {
  /// A posição de spawn usada para reiniciar a bola após colisão.
  final Vector2 initialPosition;

  bool _shouldReset = false;

  /// Cria uma nova bola e ativa o modo de debug.
  Ball([Vector2? initialPosition])
      : initialPosition = initialPosition ?? Vector2(5.0, 50.0) {
    debugMode = true;
    priority = 10; // Garante que a bola é desenhada por cima do mapa
  }

  @override
  /// Cria o corpo Forge2D da bola com uma forma circular.
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
      userData: this, // Permite identificar que este corpo é a Ball
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
    if (other is Spike || other is Goal) {
      reset();
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
