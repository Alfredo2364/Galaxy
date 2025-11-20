import 'package:flutter/material.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cinemática (mini)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'En una galaxia no muy auditada, los invasores intergalácticos '
              'se roban… ¡las facturas electrónicas! Tu misión: recuperarlas '
              'disparando con precisión y estilo. Si te preguntan de dónde '
              'sacaste la nave, di: “de un amigo”.',
              textAlign: TextAlign.justify,
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar'),
            )
          ],
        ),
      ),
    );
  }
}
