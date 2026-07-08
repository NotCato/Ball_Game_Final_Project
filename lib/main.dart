import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '/game/Ball_Prototype.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();

  final game = BallPrototype();

  runApp(GameWidget(game: game));
}
