import 'package:flame_forge2d/flame_forge2d.dart';

import '../../presentation/game/ball_prototype.dart';
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

    print("GOAL CONTACT -> ${other.runtimeType}");

    if (other is Ball) {
      print("BALL TOUCHED GOAL");

      (game as BallPrototype).onGoalReached();
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
      isSensor: true,
      userData: this,
    );

    body.createFixture(fixtureDef);

    return body;
  }
}