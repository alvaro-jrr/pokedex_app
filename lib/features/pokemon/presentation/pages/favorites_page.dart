import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex_app/features/pokemon/presentation/bloc/bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/widgets.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<PokemonBloc, PokemonState>(
            builder: (context, state) {
              if (state is Loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is LoadedFavorites) {
                final pokemons = state.pokemons;

                if (pokemons.isEmpty) {
                  return const MessageDisplay(
                    message: 'No hay favoritos por mostrar',
                  );
                }

                return FavoritesList(pokemons: pokemons);
              }

              if (state is Error) return MessageDisplay(message: state.message);

              // Start loading favorites.
              BlocProvider.of<PokemonBloc>(context).add(
                GetPokemonsFromFavorites(),
              );

              return Container();
            },
          ),
        ));
  }
}
