import 'dart:ui';
import 'package:flame/components.dart';
import '../space_game.dart';

class LivesHud extends PositionComponent with HasGameRef<SpaceGame> {
  final int Function() getLives;
  final int maxLives;

  LivesHud({
    required this.getLives,
    required this.maxLives,
    required Vector2 position,
    required int priority,
  }) : super(
          position: position,
          priority: priority,
          size: Vector2(200, 40),    // <-- espacio propio (NO invade área del juego)
        );

  Sprite? lifeSprite;
  final List<SpriteComponent> lifeIcons = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Cargar sprite solo 1 vez
    lifeSprite = Sprite(gameRef.images.fromCache('nave1.png'));

    // Crear los iconos solo una vez
    for (int i = 0; i < maxLives; i++) {
      final icon = SpriteComponent(
        sprite: lifeSprite,
        size: Vector2(26, 26),
        position: Vector2(i * 32, 0),   // separación horizontal
        anchor: Anchor.topLeft,
        priority: priority,
        paint: Paint()..color = const Color(0xFFFFFFFF),
      );

      lifeIcons.add(icon);
      add(icon);
    }

    refresh();
  }

  /// 🔄 Actualiza su opacidad según vidas restantes
  void refresh() {
    final lives = getLives();

    for (int i = 0; i < maxLives; i++) {
      final bool active = i < lives;

      lifeIcons[i].paint.color = active
          ? const Color(0xFFFFFFFF)   // Vida activa
          : const Color(0x33FFFFFF);  // Vida perdida (20%)
    }
  }
}
