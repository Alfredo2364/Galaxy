import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/space_game.dart';
import '../overlays/game_over_overlay.dart';

class PlayPage extends StatelessWidget {
  final int level;
  const PlayPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final game = SpaceGame(
      level: level,
      onWin: () {
        Navigator.pop(context, true);
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          // 🎮 El juego
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'GameOver': (context, game) =>
                  GameOverOverlay.builder(context, game),
            },
          ),

          // 🟣 Botón regresar + marcador
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    game.pauseEngine();
                    Navigator.pop(context, false);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const Spacer(),
                ValueListenableBuilder<int>(
                  valueListenable: game.score,
                  builder: (_, value, __) => Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Chip(
                      backgroundColor: Colors.black54,
                      label: Text(
                        'Score: $value',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
