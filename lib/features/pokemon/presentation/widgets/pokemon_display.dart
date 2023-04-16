import 'package:flutter/material.dart';

import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/widgets.dart';

class PokemonDisplay extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDisplay({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PokemonId(pokemon: pokemon),
        const SizedBox(height: 8),
        TypesList(types: pokemon.types),
        const SizedBox(height: 16),
        _PokemonImage(pokemon: pokemon),
        const SizedBox(height: 16),
        StatsList(stats: pokemon.stats),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _PokemonId extends StatelessWidget {
  const _PokemonId({
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          toTitleCase(pokemon.name),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '#${pokemon.id}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _PokemonImage extends StatelessWidget {
  const _PokemonImage({
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: const AssetImage('images/loading.gif'),
      image: NetworkImage(
        pokemon.sprites.other.officialArtwork.frontDefault,
      ),
      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
        'images/no-image.png',
      ),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.30,
      width: double.infinity,
      fit: BoxFit.contain,
    );
  }
}
