import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int coins = 0;
  String skin = "player_1_0.png";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      coins = p.getInt('coins') ?? 0;
      skin = p.getString('skin') ?? 'player_1_0.png';
    });
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('coins', coins);
    await p.setString('skin', skin);
  }

  void _buy(String newSkin, int price) {
    if (coins >= price) {
      coins -= price;
      skin = newSkin;
      _save();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Compra realizada!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Monedas insuficientes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tienda de Skins')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // BARRA DE MONEDAS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Monedas: $coins'),
                FilledButton(
                  onPressed: () {
                    setState(() => coins += 50); // DEBUG
                    _save();
                  },
                  child: const Text('+50'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // GRID DE SKINS
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _ItemCard(
                    image: 'assets/images/player_1_0.png',
                    label: 'Skin Roja',
                    price: 100,
                    owned: skin == 'player_1_0.png',
                    onBuy: () => _buy('player_1_0.png', 100),
                  ),
                  _ItemCard(
                    image: 'assets/images/player_2_0.png',
                    label: 'Skin Azul',
                    price: 120,
                    owned: skin == 'player_2_0.png',
                    onBuy: () => _buy('player_2_0.png', 120),
                  ),
                  _ItemCard(
                    image: 'assets/images/player_3_0.png',
                    label: 'Skin Blanco',
                    price: 150,
                    owned: skin == 'player_3_0.png',
                    onBuy: () => _buy('player_3_0.png', 150),
                  ),
                  _ItemCard(
                    image: 'assets/images/player_4_0.png',
                    label: 'Skin Dorada',
                    price: 180,
                    owned: skin == 'player_4_0.png',
                    onBuy: () => _buy('player_4_0.png', 180),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Text('Pagos reales: integrar más adelante.'),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String image;
  final String label;
  final int price;
  final bool owned;
  final VoidCallback onBuy;

  const _ItemCard({
    required this.image,
    required this.label,
    required this.price,
    required this.owned,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(child: Image.asset(image, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text(label),
            const SizedBox(height: 8),
            owned
                ? const Text(
                    'Seleccionado',
                    style: TextStyle(color: Colors.greenAccent),
                  )
                : FilledButton(
                    onPressed: onBuy,
                    child: Text('Comprar $price'),
                  ),
          ],
        ),
      ),
    );
  }
}
