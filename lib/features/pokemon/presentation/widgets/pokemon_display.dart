import 'package:flutter/material.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';

class PokemonDisplay extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDisplay({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Text(pokemon.name);
  }
}
