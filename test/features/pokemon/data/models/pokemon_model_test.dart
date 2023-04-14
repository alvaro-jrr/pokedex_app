import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_stat_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_type_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tPokemonSpritesModel = PokemonSpritesModel(
    other: OtherPokemonSprites(
      officialArtwork: OfficialArtworkSprites(frontDefault: 'Test'),
    ),
  );

  const tStatModels = [
    PokemonStatModel(baseStat: 1, stat: Stat(name: 'Test')),
  ];

  const tTypeModels = [
    PokemonTypeModel(slot: 1, type: Type(name: 'Test')),
  ];

  const tPokemonModel = PokemonModel(
    id: 1,
    name: 'Test',
    height: 1,
    weight: 1,
    sprites: tPokemonSpritesModel,
    stats: tStatModels,
    types: tTypeModels,
  );

  test(
    'should be a subclass of Pokemon entity',
    () async {
      // assert
      expect(tPokemonModel, isA<Pokemon>());
    },
  );

  group('sprites', () {
    test(
      'should return a PokemonSpritesModel',
      () async {
        // assert
        expect(tPokemonModel.sprites, isA<PokemonSpritesModel>());
      },
    );
  });

  group('stats', () {
    test(
      'should return a PokemonStatModel list',
      () async {
        // assert
        expect(tPokemonModel.stats, isA<List<PokemonStatModel>>());
      },
    );
  });

  group('types', () {
    test(
      'should return a PokemonTypeModel list',
      () async {
        // assert
        expect(tPokemonModel.types, isA<List<PokemonTypeModel>>());
      },
    );
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('pokemon.json'));

        // act
        final result = PokemonModel.fromJson(jsonMap);

        // assert
        expect(result, tPokemonModel);
      },
    );
  });

  group('copyWith', () {
    const tNewPokemonModel = PokemonModel(
      id: 1,
      name: 'New Name',
      height: 1,
      weight: 1,
      sprites: tPokemonSpritesModel,
      stats: tStatModels,
      types: tTypeModels,
      isFavorite: true,
    );

    test(
      'should return a valid model',
      () async {
        // act
        final result = tPokemonModel.copyWith();

        // assert
        expect(result, tPokemonModel);
      },
    );

    test(
      'should replace the specified properties',
      () async {
        // act
        final result = tPokemonModel.copyWith(
          name: tNewPokemonModel.name,
          isFavorite: tNewPokemonModel.isFavorite,
        );

        // assert
        expect(result, tNewPokemonModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tPokemonModel.toJson();

        // assert
        final expectedMap = {
          "id": 1,
          "name": "Test",
          "height": 1,
          "weight": 1,
          "sprites": tPokemonSpritesModel.toJson(),
          "stats": tStatModels.map((e) => e.toJson()).toList(),
          "types": tTypeModels.map((e) => e.toJson()).toList(),
          "is_favorite": tPokemonModel.isFavorite,
        };

        expect(result, expectedMap);
      },
    );
  });
}
