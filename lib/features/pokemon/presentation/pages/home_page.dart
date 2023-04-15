import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex_app/features/pokemon/presentation/bloc/bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/message_display.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_display.dart';
import 'package:pokedex_app/features/pokemon/presentation/widgets/pokemon_search.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Header(),
                  SizedBox(height: 24),
                  PokemonSearch(),
                  SizedBox(height: 24),
                  Expanded(child: Content()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Cuál Pokémon estas buscando?',
          style: textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        Text(
          'Busca un Pokémon por su nombre o utilizando su número de Pokedex.',
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

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
