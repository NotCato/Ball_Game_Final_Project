import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'ball.dart';

/// Um obstáculo estático (sensor) que reinicia a bola ao toque.
class Spike extends BodyComponent with ContactCallbacks {
  @override
  final Vector2 position;
  final Vector2 size;

  // 0.0 = totalmente transparente, 1.0 = totalmente opaco
  double opacity = 0.0;

  Spike(this.position, this.size) {
    priority = 0;
  }

  @override
  void render(Canvas canvas) {
    if (opacity > 0) {
      final paint = Paint()..color = const Color(0xFFFF0000).withOpacity(opacity);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
        paint,
      );
    }
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
    final shape = PolygonShape()..setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0);

    final fixtureDef = FixtureDef(
      shape,
      isSensor: true, // Atravessa a bola mas deteta o toque
      userData: this, // Permite identificar que este corpo é um Spike
    );

    body.createFixture(fixtureDef);
    return body;
  }
}
