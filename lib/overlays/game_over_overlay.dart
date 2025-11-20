import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Pantalla del mapa de niveles
import 'package:galaxy_force/screens/level_map_screen.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRetry;

  const GameOverOverlay({
    super.key,
    required this.onRetry,
  });

  /// Builder usado por GameWidget
  static Widget builder(BuildContext context, dynamic game) {
    return GameOverOverlay(
      onRetry: () {
        game.resumeEngine(); // seguridad por si algo quedó pausado

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
    return Stack(
      children: [
        // Fondo oscuro semitransparente
        Container(
          color: Colors.black.withOpacity(0.55),
        ),

        // Animación de fade
        Center(
          child: AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "GAME OVER",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.redAccent,
                    ),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onRetry,
                    child: Text(
                      "Regresar al mapa",
                      style: GoogleFonts.orbitron(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
