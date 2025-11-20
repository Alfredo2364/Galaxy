import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

// Bullet
import 'bullet.dart';

// Para poder llamar a loseLife() en SpaceGame
import 'package:galaxy_force/game/space_game.dart';

/// ===============================
///   TIPOS DE ENEMIGOS
/// ===============================
enum EnemyType { normal, zigzag, circular }

class Enemy extends SpriteComponent
    with HasGameRef<SpaceGame>, CollisionCallbacks {
  
  final VoidCallback onDestroyed;
  final EnemyType type;

  double dir = 1;      // dirección zig–zag
  double speed = 40;   // velocidad
  double t = 0;        // tiempo para movimiento circular

  Enemy({
    required Vector2 position,
    required this.onDestroyed,
    required this.type,
  }) : super(
          size: Vector2(44, 44),
          position: position,
          priority: 3,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    // -------------------------------
    //     SPRITE SEGÚN TIPO
    // -------------------------------

    switch (type) {
      case EnemyType.normal:
        sprite = Sprite(game.images.fromCache('enemigo1_0.png'));
        break;

      case EnemyType.zigzag:
        sprite = Sprite(game.images.fromCache('enemigo2_0.png')); 
        break;

      case EnemyType.circular:
        sprite = Sprite(game.images.fromCache('enemigo3_0.png'));
        break;
    }

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    t += dt;

    // -------------------------------
    //  MOVIMIENTOS POR TIPO
    // -------------------------------
    switch (type) {
      case EnemyType.normal:
        position.y += speed * dt;
        break;

      case EnemyType.zigzag:
        position.x += dir * speed * dt;

        if (position.x < 20 || position.x > game.size.x - 20) {
          dir *= -1;
          position.y += 20;
        }
        break;

      case EnemyType.circular:
        position.x += cos(t * 3) * 40 * dt;
        position.y += sin(t * 3) * 40 * dt;
        break;
    }

    // Si baja demasiado
    if (position.y > game.size.y + 40) {
      removeFromParent();
      onDestroyed();
    }

    // -------------------------------
    //    DISPARO ALEATORIO
    // -------------------------------
    if (Random().nextDouble() < 0.002) {
      game.add(
        Bullet(
          isPlayer: false,
          position: position + Vector2(0, 22),
        ),
      );
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    // ------------------------------------
    //     SI CHOCA CON UNA BALA DEL PLAYER
    // ------------------------------------
    if (other is Bullet && other.isPlayer) {
      other.removeFromParent();
      FlameAudio.play('hit.wav');

      onDestroyed();       // sumar puntaje + verificar fin de oleada
      removeFromParent();
    }

    super.onCollision(points, other);
  }
}
