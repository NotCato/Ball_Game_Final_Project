import 'package:flame_forge2d/flame_forge2d.dart';

import 'ball.dart';

class Goal extends BodyComponent with ContactCallbacks {
  @override
  final Vector2 position;
  final Vector2 size;

  Goal(this.position, this.size) {
    debugMode = true;
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is Ball) {
      other.reset();
    }
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

    final fixtureDef = FixtureDef(
      shape,
      isSensor: true, // A bola atravessa a meta mas deteta o toque
      userData: this, // Permite identificar que este corpo é a classe Goal
    );

    body.createFixture(fixtureDef);

    return body;
  }
}
