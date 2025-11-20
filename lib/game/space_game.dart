import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';

// COMPONENTES
import 'components/player.dart';
import 'components/enemy.dart';
import 'components/bullet.dart';

// HUD
import 'ui/lives_hud.dart';

class SpaceGame extends FlameGame
    with TapCallbacks, DragCallbacks, HasCollisionDetection {

  final int level;
  final VoidCallback onWin;

  SpaceGame({required this.level, required this.onWin});

  late Player player;
  final score = ValueNotifier<int>(0);

  int lives = 4;
  late LivesHud livesHud;

  /// 🔒 Anti doble daño
  bool damageLock = false;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'background_space.jpg',
      'nave1.png',
      'nave2.png',
      'enemigo1_0.png',
      'enemigo2_0.png',
      'enemigo3_0.png',
    ]);

    await FlameAudio.audioCache.loadAll([
      'bgm.wav',
      'shoot.wav',
      'hit.wav',
    ]);

    // Fondo
    add(SpriteComponent(
      sprite: Sprite(images.fromCache('background_space.jpg')),
      size: size,
      position: Vector2.zero(),
      priority: -10,
    ));

    // Player
    player = Player()..priority = 200;
    add(player);
    player.position = Vector2(size.x / 2, size.y - 120);

    // HUD
    livesHud = LivesHud(
      getLives: () => lives,
      maxLives: 4,
      position: Vector2(20, 20),
      priority: 300,
    );
    add(livesHud);

    // Enemigos
    _spawnWave();

    FlameAudio.loop('bgm.wav', volume: 0.3);
  }

  // ============================================================
  //          SISTEMA DE VIDA + GAME OVER + RESPAWN
  // ============================================================
  void loseLife() {
    if (damageLock) return;
    damageLock = true;

    Future.delayed(const Duration(milliseconds: 250), () {
      damageLock = false;
    });

    lives--;
    livesHud.refresh();
    shakeCamera();

    // GAME OVER ✔
    if (lives <= 0) {
      Future.microtask(() {
        overlays.add("GameOver");
        pauseEngine();                 // detiene juego
      });
      return; // No respawn
    }

    // Limpia área peligrosa al respawnear
    for (final enemy in children.whereType<Enemy>()) {
      if ((enemy.position - player.position).length < 150) {
        enemy.position.y -= 120;
      }
    }
    for (final bullet in children.whereType<Bullet>()) {
      if (!bullet.isPlayer) bullet.removeFromParent();
    }

    // Respawn del jugador
    player.position = Vector2(size.x / 2, size.y - 120);
  }

  // ============================================================
  //                    SACUDIDA
  // ============================================================
  void shakeCamera() {
    camera.viewfinder.add(
      MoveByEffect(
        Vector2(18, 18),
        EffectController(
          duration: 0.1,
          reverseDuration: 0.1,
          curve: Curves.easeInOut,
          alternate: true,
        ),
      ),
    );
  }

  // ============================================================
  //                    OLEADAS FIX
  // ============================================================
  void _spawnWave() {
    final rows = min(3 + level, 6);
    final cols = min(6 + level, 10);

    final padding = 50.0;
    final cellW = (size.x - 2 * padding) / cols;
    final startY = 80.0;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final pos = Vector2(
          padding + c * cellW + cellW / 2,
          startY + r * 60,
        );

        final enemyType =
            EnemyType.values[Random().nextInt(EnemyType.values.length)];

        add(
          Enemy(
            position: pos,
            type: enemyType,
            onDestroyed: () {
              score.value += 10;

              // ✔ Nueva oleada automática solo si NO hay enemigos
              if (children.query<Enemy>().isEmpty) {
                Future.delayed(const Duration(milliseconds: 400), () {
                  _spawnWave();
                });
              }
            },
          ),
        );
      }
    }
  }

  // Disparo
  @override
  void onTapDown(TapDownEvent event) => player.fire();

  // Movimiento
  @override
  void onDragUpdate(DragUpdateEvent event) {
    player.position += event.localDelta;
  }
}
