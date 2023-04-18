import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/bloc/bloc.dart';
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _PokemonHeader(pokemon),
        const SizedBox(height: 24),
        PokemonImage(
          pokemon,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.30,
        ),
        const SizedBox(height: 24),
        _PokemonAbout(pokemon),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _PokemonFavoriteAction extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonFavoriteAction(this.pokemon);

  /// Adds or removes the pokemon from favorites.
  void onFavoriteAction(BuildContext context) {
    if (pokemon.isFavorite) {
      BlocProvider.of<PokemonBloc>(context, listen: false).add(
        RemovePokemonFromFavorites(pokemon.id),
      );
    } else {
      BlocProvider.of<PokemonBloc>(context, listen: false).add(
        AddPokemonToFavorites(pokemon),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.favorite_border_rounded;
    Color color = Colors.grey;

    if (pokemon.isFavorite) {
      icon = Icons.favorite;
      color = Colors.red;
    }

    return IconButton(
      onPressed: () => onFavoriteAction(context),
      icon: Icon(icon, color: color),
    );
  }
}

class _PokemonHeader extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonHeader(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _PokemonFavoriteAction(pokemon),
        const SizedBox(height: 8),
        Row(
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
        ),
        const SizedBox(height: 8),
        TypesList(types: pokemon.types),
      ],
    );
  }
}

class _PokemonAbout extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonAbout(this.pokemon);

  @override
  Widget build(BuildContext context) {
    const subtitleTextStyle = TextStyle(fontSize: 24);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tamaño',
          style: subtitleTextStyle,
        ),
        const SizedBox(height: 16),
        PokemonSize(pokemon: pokemon),
        const SizedBox(height: 24),
        const Text(
          'Estadísticas',
          style: subtitleTextStyle,
        ),
        const SizedBox(height: 16),
        StatsList(stats: pokemon.stats),
      ],
    );
  }
}
