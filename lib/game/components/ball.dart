import 'package:flame_forge2d/flame_forge2d.dart';

class Ball extends BodyComponent {
  @override
  Body createBody() {
    // 1. Define as propriedades físicas do corpo.
    final bodyDef = BodyDef(
      type: BodyType.dynamic, // Dynamic = afetado por forças e gravidade.
      position: Vector2(10, 20), // Posição inicial (em metros).
    );

    final body = world.createBody(bodyDef);

    // 2. Define o formato (neste caso, um círculo de 1 metro de raio).
    final shape = CircleShape()..radius = 1;

    // 3. Cria a Fixture que une o formato ao corpo e define peso e rebote.
    body.createFixtureFromShape(
      shape,
      density: 1.0,      // Densidade/Massa.
      friction: 0.4,     // Atrito ao deslizar.
      restitution: 0.3,  // Bounciness (elasticidade/pulo).
    );

    return body;
  }
}