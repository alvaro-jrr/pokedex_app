import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex_app/features/pokemon/presentation/bloc/bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/bloc/favorites_bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/widgets.dart';
import 'package:pokedex_app/injection_container.dart' as di;

class FavoritesPage extends StatelessWidget {
  static const String routeName = 'favorites';

  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<FavoritesBloc>(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Favoritos'),
            backgroundColor: Colors.blue.shade100,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
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

                if (state is ErrorFavorites) {
                  return MessageDisplay(message: state.message);
                }

                // Start loading favorites.
                BlocProvider.of<FavoritesBloc>(context).add(
                  const GetPokemonsFromFavorites(),
                );

                return Container();
              },
            ),
          )),
    );
  }
}
