import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import 'bullet.dart';
import 'enemy.dart';
import '../space_game.dart';

class Player extends SpriteComponent
    with HasGameRef<SpaceGame>, CollisionCallbacks {

  bool isInvulnerable = false;

  late RectangleHitbox hitbox;  // <<★ guardamos hitbox

  Player()
      : super(
          size: Vector2(56, 56),
          priority: 200,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('nave1.png'));

    hitbox = RectangleHitbox();
    add(hitbox);

    position = Vector2(
      game.size.x / 2,
      game.size.y - 120,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    final double leftLimit = size.x / 2;
    final double rightLimit = game.size.x - size.x / 2;
    final double topLimit = size.y / 2;
    final double bottomLimit = game.size.y - size.y / 2;

    if (position.x < leftLimit) position.x = leftLimit;
    if (position.x > rightLimit) position.x = rightLimit;

    if (position.y < topLimit) position.y = topLimit;
    if (position.y > bottomLimit) position.y = bottomLimit;
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (isInvulnerable) return;

    if (other is Enemy || (other is Bullet && !other.isPlayer)) {
      _takeDamage();
      other.removeFromParent();
    }

    super.onCollision(points, other);
  }

  void _takeDamage() {
    if (isInvulnerable) return;

    isInvulnerable = true;
    hitbox.collisionType = CollisionType.inactive; // <<★ desactiva colisión real

    gameRef.loseLife();

    // efecto visual
    opacity = 0.4;

    // ▲ recuperación visual
    Future.delayed(const Duration(milliseconds: 200), () {
      opacity = 1.0;
    });

    // ▲ reactivar hitbox
    Future.delayed(const Duration(milliseconds: 800), () {
      isInvulnerable = false;
      hitbox.collisionType = CollisionType.active; // <<★ reactiva hitbox
    });
  }

  void fire() {
    final bulletPos = position + Vector2(0, -28);

    game.add(
      Bullet(
        isPlayer: true,
        position: bulletPos,
      ),
    );

    FlameAudio.play('shoot.wav', volume: 0.8);
  }
}
