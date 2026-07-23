import 'package:flutter/material.dart';
import 'menu.dart';

class VictoryScreen extends StatelessWidget {
  final String time;

  const VictoryScreen({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 120,
            ),

            const SizedBox(height: 20),

            const Text(
              "NÍVEL COMPLETO!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Tempo: $time",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainMenu(),
                  ),
                  (route) => false,
                );
              },
              child: const Text("Voltar ao Menu"),
            ),
          ],
        ),
      ),
    );
  }
}