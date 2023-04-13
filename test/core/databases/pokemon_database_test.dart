import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/home_sprites.dart';
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

  late Database db;

  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath);
  });

  const tPokemonModel = PokemonModel(
    id: 1,
    name: 'Test',
    height: 1,
    weight: 1,
    sprites: PokemonSprites(
      other: OtherPokemonSprites(home: HomeSprites(frontDefault: 'Test')),
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
      // act
      await db.execute('''
        CREATE TABLE Pokemon(
          id INTEGER PRIMARY KEY NOT NULL,
          data TEXT NOT NULL
        )
      ''');

      final tables = await db.query(
        'sqlite_master',
        where: 'name = ?',
        whereArgs: ['Pokemon'],
      );

      // assert
      expect(tables.length, equals(1));
    },
  );

  test(
    'should insert the pokemon',
    () async {
      // act
      await db.insert(
        'Pokemon',
        {
          'id': tPokemonModel.id,
          'data': json.encode(tPokemonModel.toJson()),
        },
      );

      final result = await db.query('Pokemon');

      // assert
      expect(result.first, {
        'id': tPokemonModel.id,
        'data': json.encode(tPokemonModel.toJson()),
      });
    },
  );

  group('data', () {
    test(
      'should be a String type',
      () async {
        // act
        final result = await db.query('Pokemon', columns: ['data']);

        // assert
        expect(result.first['data'], isA<String>());
      },
    );

    test(
      'should containg a valid JSON String',
      () async {
        // arrange

        // act
        final result = await db.query('Pokemon', columns: ['data']);

        final jsonMap = json.decode(Map.from(result.first)['data']);

        // assert
        expect(jsonMap, isA<Map<String, dynamic>>());
      },
    );

    test(
      'should get a valid pokemon',
      () async {
        // act
        final result = await db.query('Pokemon', columns: ['data']);

        final pokemonModel = PokemonModel.fromJson(
          json.decode(Map.from(result.first)['data']),
        );

        // assert
        expect(pokemonModel, isA<PokemonModel>());
      },
    );
  });

  test(
    'should delete the pokemon with the id',
    () async {
      // act
      final result = await db.delete(
        'Pokemon',
        where: 'id = ?',
        whereArgs: [tPokemonModel.id],
      );

      // assert
      expect(result, 1);
    },
  );
}
