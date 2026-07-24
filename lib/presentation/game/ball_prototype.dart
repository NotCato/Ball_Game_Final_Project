import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../data/datasources/tiled_map_component.dart';
import '../../data/services/firestore_service.dart';
import '../../domain/entities/ball.dart';

const double deadzone = 0.7;

class BallPrototype extends Forge2DGame with TapCallbacks {
  // Lista de níveis na ordem desejada
  static const List<String> levels = [
    'level_1.tmx',
    'level_2.tmx',
    'level_3.tmx',
    'level_4.tmx',
    'level_5.tmx',
  ];

  final int levelIndex; // Índice do nível atual

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  late TextComponent timerText;
  late Ball ball;
  late TiledMapComponent map;

  double elapsedTime = 0;
  bool levelCompleted = false;

  // Serviço do Firestore.
  final FirestoreService _firestoreService = FirestoreService();

  BallPrototype({this.levelIndex = 0})
      : super(
          gravity: Vector2.zero(),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = Vector2(60.2, 28.0);
    camera.viewfinder.visibleGameSize = Vector2(120.4, 56.0);

    // Carrega o mapa baseado no índice atual
    map = TiledMapComponent(levels[levelIndex]);
    await world.add(map);

    // Bola
    final spawnPoint = map.spawnPoint ?? Vector2(5.0, 50.0);
    ball = Ball(spawnPoint);
    await world.add(ball);

    // Cronómetro
    timerText = TextComponent(
      text: "⏱ 00:00",
      position: Vector2(40, 40),
      priority: 100,
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    camera.viewport.add(timerText);
    
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
  }

  // Chamado quando a bola chega à meta.
  Future<void> onGoalReached() async {
    print(">>> ON GOAL REACHED <<<");

    if (levelCompleted) return;

    levelCompleted = true;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestoreService.saveBestTime(
        uid: user.uid,
        level: levelIndex + 1,
        time: elapsedTime,
      );
    }

    final minutes = elapsedTime ~/ 60;
    final seconds = (elapsedTime % 60).floor();

    _showVictoryScreen(minutes, seconds);
  }

  // Mostra o ecrã de vitória.
  void _showVictoryScreen(int minutes, int seconds) {
    // Para a bola
    world.gravity = Vector2.zero();
    ball.body.linearVelocity = Vector2.zero();
    ball.body.angularVelocity = 0;

    final viewportSize = camera.viewport.size;

    // Fundo escuro
    camera.viewport.add(
      RectangleComponent(
        position: viewportSize / 2,
        size: viewportSize,
        anchor: Anchor.center,
        paint: Paint()..color = Colors.black.withValues(alpha: 0.75),
        priority: 500,
      ),
    );

    String message =
        "🏆 NÍVEL COMPLETO!\n\n⏱ ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    String subMessage = (levelIndex < levels.length - 1)
        ? "\n\nClica no ecrã para o PRÓXIMO NÍVEL"
        : "\n\nPARABÉNS! Completaste o jogo!";

    // Mensagem de Vitória
    camera.viewport.add(
      TextComponent(
        text: message + subMessage,
        anchor: Anchor.center,
        position: viewportSize / 2,
        priority: 501,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    // Se o nível acabou e clicarmos no ecrã
    if (levelCompleted) {
      if (levelIndex < levels.length - 1) {
        // Carrega o próximo nível reiniciando o BallPrototype
        Navigator.pushReplacement(
          buildContext!,
          MaterialPageRoute(
            builder: (_) => GameWidget(
              game: BallPrototype(levelIndex: levelIndex + 1),
            ),
          ),
        );
      } else {
        // Volta ao menu se for o último nível
        Navigator.pop(buildContext!);
      }
    }
  }

  @override
  void onRemove() {
    _accelerometerSubscription?.cancel();
    super.onRemove();
  }
}