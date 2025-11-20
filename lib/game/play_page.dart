import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/space_game.dart';

class PlayPage extends StatelessWidget {
  final int level;
  const PlayPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final game = SpaceGame(level: level, onWin: () {
      Navigator.pop(context, true);
    });
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
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
                  builder: (c, v, _) => Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Chip(label: Text('Score: $v')),
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
