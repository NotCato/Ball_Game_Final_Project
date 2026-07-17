import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Adiciona serviços para a orientação
import '/game/Ball_Prototype.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Força a orientação em modo paisagem
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  Flame.device.fullScreen(); // Esconde a barra de estado

  final game = BallPrototype();

  runApp(GameWidget(game: game));
}
