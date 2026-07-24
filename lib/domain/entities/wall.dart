import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

class Wall extends BodyComponent {
  @override
  final Vector2 position;
  final Vector2 size;

  // 0.0 = totalmente transparente, 1.0 = totalmente opaco
  double opacity = 0.0;

  Wall(this.position, this.size) {
    priority = 0;
  }

  @override
  void render(Canvas canvas) {
    if (opacity > 0) {
      final paint = Paint()..color = const Color(0xFFFFFFFF).withOpacity(opacity);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
        paint,
      );
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