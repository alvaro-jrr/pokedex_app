import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:pokedex_app/core/databases/pokemon_database.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_type.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation.
  sqfliteFfiInit();

  // Set global factory.
  databaseFactory = databaseFactoryFfi;
}

Future main() async {
  sqfliteTestInit();

  late PokemonDatabase pokemonDatabase;

  setUp(() async {
    pokemonDatabase = PokemonDatabase(path: inMemoryDatabasePath);
  });

  const tId = 1;
  const tName = 'Test';

  const tPokemonModel = PokemonModel(
    id: tId,
    name: tName,
    height: 1,
    weight: 1,
    sprites: PokemonSprites(
      other: OtherPokemonSprites(
        officialArtwork: OfficialArtworkSprites(frontDefault: 'Test'),
      ),
    ),
    stats: [
      PokemonStat(baseStat: 1, stat: Stat(name: 'Test')),
    ],
    types: [
      PokemonType(slot: 1, type: Type(name: 'Test')),
    ],
  );

  test(
    'should create the Pokemon table',
    () async {
      // arrange
      final db = await pokemonDatabase.database;

      // act
      final tables = await db.query(
        'sqlite_master',
        where: 'name = ?',
        whereArgs: ['Pokemon'],
      );

      // assert
      expect(tables.length, equals(1));
    },
  );

  group('newPokemon', () {
    test(
      'should insert the pokemon',
      () async {
        // act
        final result = await pokemonDatabase.newPokemon(tPokemonModel);

        // assert
        expect(result, 1);
      },
    );
  });

  group('getPokemonById', () {
    test(
      'should return a Pokemon that matches the id',
      () async {
        // act
        final result = await pokemonDatabase.getPokemonById(tId);

        // assert
        expect(result, tPokemonModel);
      },
    );

    test(
      'should not return a Pokemon when the id is not found',
      () async {
        // arrange
        const tNotInsertedId = 0;

        // act
        final result = await pokemonDatabase.getPokemonById(tNotInsertedId);

        // assert
        expect(result, null);
      },
    );
  });

  group('getPokemonByName', () {
    test(
      'should return a Pokemon that matches the name',
      () async {
        // act
        final result = await pokemonDatabase.getPokemonByName(tName);

        // assert
        expect(result, tPokemonModel);
      },
    );

    test(
      'should not return a Pokemon when the name is not found',
      () async {
        // arrange
        const tNotInsertedName = 'Name Test';

        // act
        final result = await pokemonDatabase.getPokemonByName(tNotInsertedName);

        // assert
        expect(result, null);
      },
    );
  });

  group('getPokemons', () {
    test(
      'should return a Pokemon list',
      () async {
        // act
        final result = await pokemonDatabase.getPokemons();

        // assert
        expect(result, isA<List<PokemonModel>>());
      },
    );
  });

  group('deletePokemon', () {
    test(
      'should delete the pokemon',
      () async {
        // act
        final result = await pokemonDatabase.deletePokemon(tId);

        // assert
        expect(result, 1);
      },
    );
  });
}
