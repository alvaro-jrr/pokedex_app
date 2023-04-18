import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/widgets.dart';

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
      ),
      itemBuilder: (context, index) => GestureDetector(
        child: _FavoriteCard(pokemons[index]),
        onTap: () {
          // Set the Pokemon as selected.
          BlocProvider.of<PokemonBloc>(context).add(
            GetPokemonForConcreteQuery(pokemons[index].name),
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
          Expanded(child: PokemonImage(pokemon)),
          const SizedBox(height: 8),
          Text(
            toTitleCase(pokemon.name, separator: '-'),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
