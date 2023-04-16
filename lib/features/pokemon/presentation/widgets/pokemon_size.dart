import 'package:flutter/material.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';

class PokemonSize extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonSize({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SizeCard(
            title: 'Estatura',
            size: pokemon.height,
            type: 'dm',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SizeCard(
            title: 'Peso',
            size: pokemon.weight,
            type: 'hg',
          ),
        ),
      ],
    );
  }
}

class _SizeCard extends StatelessWidget {
  final String title;
  final int size;
  final String? type;

  const _SizeCard({
    required this.title,
    required this.size,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final description = type == null ? '$size' : '$size $type';

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(description),
        ],
      ),
    );
  }
}
