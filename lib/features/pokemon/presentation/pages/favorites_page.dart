import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  static const String routeName = 'favorites';

  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favoritos'),
          backgroundColor: Colors.blue.shade100,
        ),
        body: const Center(child: Text('Empty')));
  }
}
