import 'package:flame_forge2d/flame_forge2d.dart';

class Wall extends BodyComponent {
  final Vector2 position;
  final Vector2 size;

  Wall(this.position, this.size);

  @override
  Body createBody() {
    // Corpos estáticos (Static) não se movem e não sofrem gravidade.
    // São ideais para chão, paredes e obstáculos fixos.
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: position,
    );

    final body = world.createBody(bodyDef);

    // setAsBox recebe METADE da largura e METADE da altura.
    // O ponto de origem (centro) fica no meio do retângulo.
    final shape = PolygonShape()
      ..setAsBox(
        size.x / 2,
        size.y / 2,
        Vector2.zero(),
        0,
      );

    body.createFixtureFromShape(shape);

    return body;
  }
}