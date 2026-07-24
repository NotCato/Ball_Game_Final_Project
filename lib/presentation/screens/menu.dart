import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../game/ball_prototype.dart';
import 'login_screen.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // Serviço de autenticação.
  final AuthService _authService = AuthService();

  // Serviço do Firestore.
  final FirestoreService _firestoreService = FirestoreService();

  // Guarda os melhores tempos do utilizador.
  Map<String, dynamic> _bestTimes = {};

  @override
  void initState() {
    super.initState();
    _loadBestTimes();
  }

  // Obtém os melhores tempos.
  Future<void> _loadBestTimes() async {
    final user = _authService.currentUser;

    if (user == null) return;

    final bestTimes =
        await _firestoreService.getBestTimes(user.uid);

    if (!mounted) return;

    setState(() {
      _bestTimes = bestTimes;
    });
  }

  // Termina a sessão.
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

  // Cria uma linha para cada nível.
  Widget _buildTimeTile(int level) {
    final value = _bestTimes['level_$level'];

    String time = "--";

    if (value != null) {
      final minutes = (value ~/ 60).toInt();
      final seconds = (value % 60).floor();

      time =
          "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "Level $level : $time",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Melhores Tempos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _buildTimeTile(1),
                _buildTimeTile(2),
                _buildTimeTile(3),
                _buildTimeTile(4),
                _buildTimeTile(5),

                const SizedBox(height: 40),

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

                // Fecha a sessão.
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                  ),
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}