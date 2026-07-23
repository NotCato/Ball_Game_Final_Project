import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame_prototype/game/components/ball.dart';

void main() {
  group('Ball', () {
    test('uses provided spawn position', () {
      final position = Vector2(10.0, 20.0);
      final ball = Ball(position);

      expect(ball.initialPosition, equals(position));
    });

    test('falls back to default spawn position when none provided', () {
      final ball = Ball();

      expect(ball.initialPosition, equals(Vector2(5.0, 50.0)));
    });
  });
}
