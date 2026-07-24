import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../data/services/auth_service.dart';
import '../presentation/game/ball_prototype.dart';
import '../presentation/screens/login_screen.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // Serviço de autenticação.
  final AuthService _authService = AuthService();

  // Termina a sessão do utilizador.
  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "TILT MAZE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Inclina o telemóvel para mover a bola",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 50),

            // Inicia o jogo.
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 20,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameWidget(
                      game: BallPrototype(),
                    ),
                  ),
                );
              },
              child: const Text(
                "JOGAR",
                style: TextStyle(fontSize: 24),
              ),
            ),

            const SizedBox(height: 20),

            // Termina a sessão.
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 20,
                ),
              ),
              child: const Text(
                "LOGOUT",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}