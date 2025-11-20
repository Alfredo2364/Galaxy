import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:galaxy_force/screens/menu_screen.dart';
import 'package:galaxy_force/screens/level_map_screen.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRetry;

  const GameOverOverlay({
    super.key,
    required this.onRetry,
  });

  static Widget builder(BuildContext context, dynamic game) {
    return GameOverOverlay(
      onRetry: () {
        game.resumeEngine(); // seguridad

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LevelMapScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("GAME OVER",
                style: GoogleFonts.orbitron(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("Regresar al mapa"),
            ),
          ],
        ),
      ),
    );
  }
}
