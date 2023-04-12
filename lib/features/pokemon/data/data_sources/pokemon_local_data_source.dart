import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  /// Gets the favorite [PokemonModel] that matches the [id].
  ///
  /// Throws [CacheException] if Pokemon with [id] not found.
  Future<PokemonModel> getFavoritePokemon(int id);

  /// Gets the [PokemonModel] favorites list.
  Future<List<PokemonModel>> getFavoritePokemons();

  /// Adds the [PokemonModel] into the favorites list.
  Future<void> addFavoritePokemon(PokemonModel pokemon);

  /// Removes the [PokemonModel] from the favorites list with the [id].
  ///
  /// Throws [CacheException] if Pokemon with [id] not found.
  Future<void> removeFavoritePokemon(int id);
}
