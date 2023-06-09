import 'package:dartz/dartz.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  /// Gets a concrete [Pokemon] that matches the [query].
  Future<Either<Failure, Pokemon>> getConcretePokemon(String query);

  /// Gets the [Pokemon] favorites list.
  Future<Either<Failure, List<Pokemon>>> getFavoritePokemons();

  /// Adds the [Pokemon] into the favorites list.
  Future<Either<Failure, Pokemon>> addFavoritePokemon(Pokemon pokemon);

  /// Removes the [Pokemon] from the favorites list with the [id].
  Future<Either<Failure, Pokemon>> removeFavoritePokemon(int id);
}
