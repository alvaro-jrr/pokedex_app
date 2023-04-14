import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/official_artwork_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tOfficialArtworkModel = OfficialArtworkSpritesModel(
    frontDefault: 'Test',
  );

  test(
    'should be a subclass of OfficialArtworkSprites entity',
    () async {
      // assert
      expect(tOfficialArtworkModel, isA<OfficialArtworkSprites>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('official_artwork_sprites.json'));

        // act
        final result = OfficialArtworkSpritesModel.fromJson(jsonMap);

        // assert
        expect(result, tOfficialArtworkModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tOfficialArtworkModel.toJson();

        // assert
        final expectedMap = {
          "front_default": "Test",
        };

        expect(result, expectedMap);
      },
    );
  });
}
