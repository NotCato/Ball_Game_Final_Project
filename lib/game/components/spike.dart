import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/collisions.dart';
import 'ball.dart';

class Spike extends PositionComponent with CollisionCallbacks {
  @override
  void onCollision(Set<Vector2> points,PositionComponent other) {
    if (other is Ball){

    }
  }

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