import 'package:flutter/material.dart';
import 'play_screen.dart';
import 'level_map_screen.dart';
import 'shop_screen.dart';
import 'story_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A), // azul profundo
              Color(0xFF1E293B),
              Color(0xFF312E81), // morado sutil
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 🛸 Título del juego
            Text(
              'GALAXY FORCE',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              'Aventura espacial • Historia galáctica • Arcade',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 32),
            const Spacer(),

            // === Botones del menú ===

            _MenuButton(
              icon: Icons.play_arrow_rounded,
              label: 'Jugar',
              subtitle: 'Modo campaña o arcade',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlayScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            _MenuButton(
              icon: Icons.map_rounded,
              label: 'Mapa de Niveles',
              subtitle: 'Progreso tipo Candy Crush',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LevelMapScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            _MenuButton(
              icon: Icons.shopping_cart_rounded,
              label: 'Tienda Galáctica',
              subtitle: 'Skins, mejoras, accesorios',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            _MenuButton(
              icon: Icons.movie_filter_rounded,
              label: 'Historia / Cinemática',
              subtitle: 'Conoce el origen del piloto',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StoryScreen()),
                );
              },
            ),

            const Spacer(),

            // --- Monedas / Estrellas (placeholder editable) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '💎 Monedas: 0',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '⭐ Estrellas: 0/30',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
//                  COMPONENTE REUTILIZABLE
// ==========================================================

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF111827),
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 36, color: Colors.white70),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey[400],
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
