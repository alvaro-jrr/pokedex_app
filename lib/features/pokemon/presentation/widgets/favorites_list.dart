import 'package:flutter/material.dart';

import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';

class FavoritesList extends StatelessWidget {
  final List<Pokemon> pokemons;

  const FavoritesList({super.key, required this.pokemons});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 200,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) => _FavoriteCard(pokemons[index]),
      itemCount: pokemons.length,
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Pokemon pokemon;

  const _FavoriteCard(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInImage(
            placeholder: const AssetImage('images/loading.gif'),
            image: NetworkImage(
              pokemon.sprites.other.officialArtwork.frontDefault,
            ),
            imageErrorBuilder: (context, error, stackTrace) => Image.asset(
              'images/no-image.jpg',
            ),
            fit: BoxFit.contain,
          ),
          Text(
            toTitleCase(pokemon.name),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
