import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/home_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/home_sprites.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tHomeSpritesModel = HomeSpritesModel(frontDefault: 'Test');

  test(
    'should be a subclass of HomeSprites entity',
    () async {
      // assert
      expect(tHomeSpritesModel, isA<HomeSprites>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('home_sprites.json'));

        // act
        final result = HomeSpritesModel.fromJson(jsonMap);

        // assert
        expect(result, tHomeSpritesModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tHomeSpritesModel.toJson();

        // assert
        final expectedMap = {
          "front_default": "Test",
        };

        expect(result, expectedMap);
      },
    );
  });
}
