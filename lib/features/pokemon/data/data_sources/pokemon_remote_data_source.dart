import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  /// Calls the https://pokeapi.co/api/v2/[query] endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<PokemonModel> getConcretePokemon(String query);
}
