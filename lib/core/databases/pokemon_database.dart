import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';

class PokemonDatabase {
  /// The database instance.
  static Database? _database;

  static final PokemonDatabase db = PokemonDatabase._();

  PokemonDatabase._();

  /// The database instance.
  Future<Database> get database async {
    // Returns database in case is already instanced
    if (_database != null) return _database!;

    // Initialize DB
    _database = await initDB();
    return _database!;
  }

  /// Creates the tables in the [db].
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Pokemon(
        id INTEGER PRIMARY KEY NOT NULL,
        data TEXT NOT NULL,
      )
    ''');
  }

  /// Initializes the database.
  Future<Database> initDB() async {
    // Path where is going to be stored the DB
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pokemon.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Inserts a new [pokemon].
  Future<int> newPokemon(PokemonModel pokemon) async {
    final db = await database;

    // Insert the pokemon.
    return await db.insert(
      'Pokemon',
      {
        'id': pokemon.id,
        'data': json.encode(pokemon.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes the pokemon with [id].
  Future<int> deletePokemon(int id) async {
    final db = await database;

    return await db.delete('Pokemon', where: 'id = ?', whereArgs: [id]);
  }

  /// Gets a [PokemonModel] list.
  Future<List<PokemonModel>> getPokemons() async {
    final db = await database;
    final List<PokemonModel> pokemons = [];

    final pokemonsJson = await db.query('Pokemon', columns: ['id']);

    for (final pokemonJson in pokemonsJson) {
      final Map<String, int> pokemonMap = Map.from(pokemonJson);
      final pokemon = await getPokemonById(pokemonMap['id']!);

      if (pokemon != null) pokemons.add(pokemon);
    }

    return pokemons;
  }

  /// Gets the pokemon with [id].
  Future<PokemonModel?> getPokemonById(int id) async {
    final db = await database;

    final pokemonJson = await db.query(
      'Pokemon',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (pokemonJson.isEmpty) return null;

    final Map<String, dynamic> pokemon = Map.from(pokemonJson.first);
    return PokemonModel.fromJson(pokemon['data']);
  }
}
