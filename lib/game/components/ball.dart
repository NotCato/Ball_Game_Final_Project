import 'package:flame/collisions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

/// Uma bola física controlada pela inclinação do dispositivo e reiniciada ao bater em espinhos.
class Ball extends BodyComponent with CollisionCallbacks {
  /// A posição de spawn usada para reiniciar a bola após colisão.
  static final Vector2 initialPosition = Vector2(5.0, 50.0);

  /// Cria uma nova bola e ativa o modo de debug.
  Ball() {
    debugMode = true;
    priority = 10; // Garante que a bola é desenhada por cima do mapa
  }

  @override
  /// Cria o corpo Forge2D da bola com uma forma circular.
  Body createBody() {
    // 1. Define as propriedades físicas do corpo.
    final bodyDef = BodyDef(
      type: BodyType.dynamic, // Dynamic = afetado por forças e gravidade.
      position: initialPosition,
      linearDamping: 0.5,  // Adiciona "atrito" com o ar/mesa para parar a bola.
      angularDamping: 0.5, // Adiciona atrito na rotação.
      allowSleep: false,   // Mantém a bola acordada para responder à gravidade.
    );

    final body = world.createBody(bodyDef);

    // 2. Define o formato (neste caso, um círculo de 1 metro de raio).
    final shape = CircleShape()..radius = 1;

    // 3. Cria a Fixture que une o formato ao corpo e define peso e rebote.
    body.createFixtureFromShape(
      shape,
      density: 1.0,      // Densidade/Massa.
      friction: 0.2,     // Atrito ao deslizar.
      restitution: 0.3,  // Bounciness (elasticidade/pulo).
    );

    return body;
  }

  /// Reinicia a bola para a sua posição de spawn inicial e anula a velocidade.
  void reset() {
    body.setTransform(initialPosition, 0.0);
    body.linearVelocity = Vector2.zero();
    body.angularVelocity = 0;
  }
}
