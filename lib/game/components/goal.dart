import 'package:flame/collisions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Goal extends BodyComponent with CollisionCallbacks {
  @override
  final Vector2 position;

  final Vector2 size;

  Goal(this.position, this.size) {
    debugMode = true;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: position,
    );

    final body = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        size.x / 2,
        size.y / 2,
        Vector2.zero(),
        0,
      );

    body.createFixture(
      FixtureDef(
        shape,
        isSensor: true,
      ),
    );

    return body;
  }
}