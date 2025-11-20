import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../game/play_page.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  int unlocked = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // =====================================================
  //       CARGAR PROGRESO DE NIVELES DESBLOQUEADOS
  // =====================================================
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => unlocked = prefs.getInt('unlocked_levels') ?? 1);
  }

  // =====================================================
  //       GUARDAR PROGRESO DE NIVELES DESBLOQUEADOS
  // =====================================================
  Future<void> _save(int newUnlocked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unlocked_levels', newUnlocked);
  }

  // =====================================================
  //                     UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Niveles')),
      body: Stack(
        children: [
          // Fondo espacial
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_space.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Lista de niveles
          ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: 6, // cantidad de niveles
            itemBuilder: (context, index) {
              final level = index + 1;
              final enabled = level <= unlocked + 1;

              return Opacity(
                opacity: enabled ? 1.0 : 0.35,
                child: Card(
                  color: Colors.black54,
                  child: ListTile(
                    title: Text('Nivel $level'),
                    subtitle: const Text('Elimina a todos los enemigos'),
                    trailing: Icon(
                      enabled ? Icons.play_arrow : Icons.lock_outline,
                      color: enabled ? Colors.greenAccent : Colors.grey,
                    ),

                    // SOLO SE PUEDE PRESIONAR SI ESTÁ DESBLOQUEADO
                    onTap: enabled
                        ? () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayPage(level: level),
                              ),
                            );

                            // Si ganó el nivel, desbloquearlo
                            if (result == true && level >= unlocked) {
                              setState(() => unlocked = level);
                              _save(unlocked);
                            }
                          }
                        : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
