import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';

class PokemonDatabase {
  /// The [path] to store this database.
  final String path;
  Database? _database;

  PokemonDatabase({required this.path});

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
        name TEXT UNIQUE,
        data TEXT NOT NULL
      )
    ''');
  }

  /// Initializes the database.
  Future<Database> initDB() async {
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
        'name': pokemon.name,
        'data': json.encode(pokemon.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes the pokemon with [id].
  Future<int> deletePokemon(int id) async {
    final db = await database;

    return await db.delete(
      'Pokemon',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Gets a [PokemonModel] list.
  Future<List<PokemonModel>> getPokemons() async {
    final db = await database;
    final pokemonsJson = await db.query('Pokemon', columns: ['data']);

    return pokemonsJson.map((pokemonJson) => _getPokemon(pokemonJson)).toList();
  }

  /// Gets the pokemon with [id].
  Future<PokemonModel?> getPokemonById(int id) async {
    final db = await database;

    final jsonResponse = await db.query(
      'Pokemon',
      where: 'id = ?',
      whereArgs: [id],
    );

    return jsonResponse.isEmpty ? null : _getPokemon(jsonResponse.first);
  }

  /// Gets the pokemon with [name].
  Future<PokemonModel?> getPokemonByName(String name) async {
    final db = await database;

    final jsonResponse = await db.query(
      'Pokemon',
      where: 'name = ?',
      whereArgs: [name],
    );

    return jsonResponse.isEmpty ? null : _getPokemon(jsonResponse.first);
  }

  PokemonModel _getPokemon(Map<String, Object?> jsonResponse) {
    return PokemonModel.fromJson(
      json.decode(
        Map.from(jsonResponse)['data'],
      ),
    );
  }
}
