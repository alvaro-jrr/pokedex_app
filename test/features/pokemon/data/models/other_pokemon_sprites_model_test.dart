import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/home_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/other_pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tHomeSpritesModel = HomeSpritesModel(frontDefault: 'Test');

  const tOtherPokemonSpritesModel = OtherPokemonSpritesModel(
    home: tHomeSpritesModel,
  );

  test(
    'should be a subclass of OtherPokemonSprites entity',
    () async {
      // assert
      expect(tOtherPokemonSpritesModel, isA<OtherPokemonSprites>());
    },
  );

  group('home', () {
    test(
      'should return a HomeSpritesModel',
      () async {
        // assert
        expect(tOtherPokemonSpritesModel.home, isA<HomeSpritesModel>());
      },
    );
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('other_pokemon_sprites.json'));

        // act
        final result = OtherPokemonSpritesModel.fromJson(jsonMap);

        // assert
        expect(result, tOtherPokemonSpritesModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tOtherPokemonSpritesModel.toJson();

        // assert
        final expectedMap = {
          "home": tHomeSpritesModel.toJson(),
        };

        expect(result, expectedMap);
      },
    );
  });
}
