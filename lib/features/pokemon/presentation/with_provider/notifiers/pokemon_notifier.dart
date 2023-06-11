import 'package:flutter/material.dart';

import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/add_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_concrete_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';

/// The [PokemonsNotifier] holds the selected/searched Pokemon
/// by the user and its actions to add or remove it from its
/// favorite list.
class PokemonsNotifier with ChangeNotifier {
  final AddFavoritePokemon addFavoritePokemon;
  final GetConcretePokemon getConcretePokemon;
  final GetFavoritePokemons getFavoritePokemons;
  final RemoveFavoritePokemon removeFavoritePokemon;

  PokemonsNotifier({
    required this.addFavoritePokemon,
    required this.getConcretePokemon,
    required this.getFavoritePokemons,
    required this.removeFavoritePokemon,
  });

  /// The selected pokemon.
  Pokemon? currentPokemon;

  /// The error message
  String error = '';

  /// Adds the [pokemon] in the favorites list.
  Future<void> addPokemon(Pokemon pokemon) async {
    final failureOrPokemon = await addFavoritePokemon(
      AddFavoritePokemonParams(pokemon: pokemon),
    );

    failureOrPokemon.fold(
      (failure) => error = mapFailureToMessage(failure),
      (pokemon) => currentPokemon = pokemon,
    );

    notifyListeners();
  }
}
