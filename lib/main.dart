import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GalaxyForceApp());
}

class GalaxyForceApp extends StatelessWidget {
  const GalaxyForceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galaxy Force',
      debugShowCheckedModeBanner: false,

      // 🎨 Tema moderno
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6D28D9),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.orbitronTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),

      // 🏠 Pantalla inicial → MenuScreen
      home: const MenuScreen(),
    );
  }
}
