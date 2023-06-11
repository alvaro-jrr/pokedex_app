import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex_app/features/pokemon/presentation/with_bloc/bloc/bloc.dart';

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({super.key});

  @override
  State<PokemonSearch> createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  final controller = TextEditingController();
  String inputStr = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) => inputStr = value,
      onSubmitted: (_) => addConcrete(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelText: 'Pokémon',
        hintText: 'ej: pikachu, ditto, 1',
        suffixIcon: const Icon(Icons.search),
      ),
    );
  }

  void addConcrete() {
    // Clear field.
    controller.clear();

    BlocProvider.of<PokemonBloc>(context, listen: false).add(
      GetPokemonForConcreteQuery(inputStr),
    );

    // Clear value.
    inputStr = '';
  }
}
