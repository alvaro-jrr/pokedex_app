import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex_app/features/pokemon/presentation/bloc/bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/pages/pages.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Tu Pokédex'),
            backgroundColor: Colors.blue.shade100,
            actions: [
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: Text('Lista de Favoritos'),
                    )
                  ];
                },
                onSelected: (_) {
                  Navigator.pushNamed(
                    context,
                    FavoritesPage.routeName,
                  );

                  // Remove focus on text field when returning to this page.
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              )
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Header(),
                  SizedBox(height: 24),
                  Expanded(child: _Content()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Busca un Pokémon por su nombre o utilizando su número de Pokédex.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        const PokemonSearch()
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is Error) return MessageDisplay(message: state.message);

        if (state is LoadedPokemon) {
          return PokemonDisplay(pokemon: state.pokemon);
        }

        return const MessageDisplay(message: 'No has buscado un Pokémon aún');
      },
    );
  }
}
