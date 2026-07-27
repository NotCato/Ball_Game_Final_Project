import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../../game/ball_prototype.dart';
import 'ball.dart';

class Goal extends BodyComponent with ContactCallbacks {
  @override
  final Vector2 position;

  final Vector2 size;

  // 0.0 = totalmente transparente, 1.0 = totalmente opaco
  double opacity = 0.0;

  Goal(this.position, this.size) {
    priority = 0;
  }

  @override
  void render(Canvas canvas) {
    if (opacity > 0) {
      final paint = Paint()..color = const Color(0xFF00FF00).withOpacity(opacity);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
        paint,
      );
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    print("GOAL CONTACT -> ${other.runtimeType}");

    if (other is Ball) {
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