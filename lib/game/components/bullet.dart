import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:galaxy_force/game/space_game.dart';
import 'player.dart';

class Bullet extends RectangleComponent
    with HasGameRef, CollisionCallbacks {
  final bool isPlayer;

  Bullet({
    required this.isPlayer,
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(6, 18),
          priority: 4,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    // Color según origen
    paint = Paint()
      ..color = isPlayer
          ? const Color(0xFF80D4FF) // azul jugador
          : const Color(0xFFFF6B6B); // rojo enemigo

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Velocidad más natural para shooter vertical
    const double playerSpeed = -380;
    const double enemySpeed = 250;

    position.y += isPlayer ? playerSpeed * dt : enemySpeed * dt;

    // Eliminar si sale de pantalla
    if (position.y < -40 || position.y > game.size.y + 40) {
      removeFromParent();
    }
  }

  // ==================================
  //      DAÑO AL JUGADOR
  // ==================================
  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (!isPlayer && other is Player) {
      (gameRef as SpaceGame).loseLife();
      removeFromParent();
    }

    super.onCollision(points, other);
  }
}
