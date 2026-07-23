import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'components/ball.dart';
import 'components/tiled_map_component.dart';

const double deadzone = 0.7;

class BallPrototype extends Forge2DGame {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  late TextComponent timerText;

  late Ball ball;
  late TiledMapComponent map;

  double elapsedTime = 0;
  bool levelCompleted = false;

  BallPrototype()
      : super(
          gravity: Vector2.zero(),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = Vector2(60.2, 28.0);
    camera.viewfinder.visibleGameSize = Vector2(120.4, 56.0);

    // Mapa
    map = TiledMapComponent();
    await world.add(map);

    // Bola
    ball = Ball(Vector2(5.0, 50.0));
    await world.add(ball);

    // Cronómetro
    timerText = TextComponent(
      text: "⏱ 00:00",
      position: Vector2(25, 20),
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    add(timerText);
    
    // Sensor
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      if (levelCompleted) return;

      double applyDeadzone(double value) {
        if (value.abs() < deadzone) {
          return 0.0;
        }
        return value;
      }

      world.gravity.setValues(
        applyDeadzone(event.y) * 5.0,
        applyDeadzone(event.x) * 5.0,
      );
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (levelCompleted) return;

    elapsedTime += dt;

    final minutes = elapsedTime ~/ 60;
    final seconds = (elapsedTime % 60).floor();

    timerText.text =
        "⏱ ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    // Vitória
    if (map.goalPoint != null &&
        ball.body.position.distanceTo(map.goalPoint!) < 1.5) {
      levelCompleted = true;

      // Para a bola
      world.gravity = Vector2.zero();
      ball.body.linearVelocity = Vector2.zero();
      ball.body.angularVelocity = 0;

      // Fundo escuro
      add(
        RectangleComponent(
          position: Vector2.zero(),
          size: size,
          paint: Paint()..color = Colors.black.withOpacity(0.75),
          priority: 500,
        ),
      );

      // Mensagem
      add(
        TextComponent(
          text:
              "🏆 NÍVEL COMPLETO!\n\n⏱ ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
          anchor: Anchor.center,
          position: size / 2,
          priority: 501,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  @override
  void onRemove() {
    _accelerometerSubscription?.cancel();
    super.onRemove();
  }
}