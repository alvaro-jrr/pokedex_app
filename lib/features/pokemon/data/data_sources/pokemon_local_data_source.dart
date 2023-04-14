import 'package:pokedex_app/core/databases/pokemon_database.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  /// Gets the favorite [PokemonModel] that matches the [id].
  ///
  /// Throws [CacheException] if Pokemon with [id] not found.
  Future<PokemonModel> getFavoritePokemonById(int id);

  /// Gets the favorite [PokemonModel] that matches the [name].
  ///
  /// Throws [CacheException] if Pokemon with [name] not found.
  Future<PokemonModel> getFavoritePokemonByName(String name);

  /// Gets the [PokemonModel] favorites list.
  ///
  /// Throws [CacheException] on any error.
  Future<List<PokemonModel>> getFavoritePokemons();

  /// Adds the [PokemonModel] into the favorites list.
  ///
  /// Throws [CacheException] on any error.
  Future<void> addFavoritePokemon(PokemonModel pokemon);

  /// Removes the [PokemonModel] from the favorites list with the [id].
  ///
  /// Throws [CacheException] if Pokemon with [id] not found.
  Future<void> removeFavoritePokemon(int id);
}

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final PokemonDatabase database;

  PokemonLocalDataSourceImpl({required this.database});

  @override
  Future<PokemonModel> getFavoritePokemonById(int id) async {
    try {
      final pokemon = await database.getPokemonById(id);

      if (pokemon == null) throw CacheException();

      return pokemon;
    } catch (error) {
      throw CacheException();
    }
  }

  @override
  Future<PokemonModel> getFavoritePokemonByName(String name) async {
    try {
      final pokemon = await database.getPokemonByName(name);

      if (pokemon == null) throw CacheException();

      return pokemon;
    } catch (error) {
      throw CacheException();
    }
  }

  @override
  Future<List<PokemonModel>> getFavoritePokemons() async {
    try {
      return await database.getPokemons();
    } catch (error) {
      throw CacheException();
    }
  }

  @override
  Future<void> addFavoritePokemon(PokemonModel pokemon) async {
    try {
      await database.newPokemon(pokemon);
    } catch (error) {
      throw CacheException();
    }
  }

  @override
  Future<void> removeFavoritePokemon(int id) async {
    try {
      await database.deletePokemon(id);
    } catch (error) {
      throw CacheException();
    }
  }
}
