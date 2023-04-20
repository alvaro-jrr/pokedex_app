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
        mainAxisExtent: 220,
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
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox.expand(
                child: PokemonImage(pokemon),
              ),
            ),
            const SizedBox(height: 8),
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
            Text('#${pokemon.id}')
          ],
        ),
      ),
    );
  }
}
