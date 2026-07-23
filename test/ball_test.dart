import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame_prototype/game/components/ball.dart';
import 'package:flame_prototype/game/components/spike.dart';
import 'package:flame_prototype/game/components/goal.dart';

class TestBall extends Ball {
  bool resetCalled = false;

  @override
  void reset() {
    resetCalled = true;
    super.reset();
  }
}

class FakeContact extends Fake implements Contact {}

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

  group('Spike', () {
    test('resets the ball on contact', () {
      final spike = Spike(Vector2.zero(), Vector2.all(1.0));
      final ball = TestBall();

      spike.beginContact(ball, FakeContact());

      expect(ball.resetCalled, isTrue);
    });
  });

  group('Goal', () {
    test('resets the ball on contact', () {
      final goal = Goal(Vector2.zero(), Vector2.all(1.0));
      final ball = TestBall();

      goal.beginContact(ball, FakeContact());

      expect(ball.resetCalled, isTrue);
    });
  });
}
