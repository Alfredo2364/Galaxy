import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/space_game.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = SpaceGame(
      level: 1,
      onWin: () {
        // Cuando gana el jugador
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Nivel completado! ⭐"),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),

          // Botón atrás
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                      game.onRemove(); // detener audio
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
