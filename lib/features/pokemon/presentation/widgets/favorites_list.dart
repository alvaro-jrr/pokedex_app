import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/widgets.dart';
import 'package:pokedex_app/features/pokemon/presentation/with_bloc/bloc/favorites_bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/with_bloc/bloc/pokemon_bloc.dart';

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
        mainAxisExtent: 250,
      ),
      itemBuilder: (context, index) => GestureDetector(
        child: _FavoriteCard(
          pokemon: pokemons[index],
          pokemons: pokemons,
        ),
        onTap: () {
          // Set the Pokemon as selected.
          BlocProvider.of<PokemonBloc>(context).add(
            SetConcretePokemon(pokemons[index]),
          );

          Navigator.pop(context);
        },
      ),
      itemCount: pokemons.length,
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Pokemon pokemon;
  final List<Pokemon> pokemons;

  const _FavoriteCard({
    required this.pokemon,
    required this.pokemons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => addRemoveFavorite(context),
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SizedBox.expand(
                child: PokemonImage(pokemon),
              ),
            ),
            const SizedBox(height: 8),
            _PokemonAbout(pokemon),
          ],
        ),
      ),
    );
  }

  void addRemoveFavorite(BuildContext context) {
    // Remove this pokemon.
    BlocProvider.of<FavoritesBloc>(context, listen: false).add(
      RemoveFavoriteFromFavorites(
        pokemons: pokemons,
        id: pokemon.id,
      ),
    );
  }
}

class _PokemonAbout extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonAbout(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            toTitleCase(
              pokemon.name,
              separator: '-',
            ),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text('#${pokemon.id}'),
        ],
      ),
    );
  }
}
