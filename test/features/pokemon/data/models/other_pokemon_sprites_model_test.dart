import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/official_artwork_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/other_pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tOfficialArtworkSpritesModel = OfficialArtworkSpritesModel(
    frontDefault: 'Test',
  );

  const tOtherPokemonSpritesModel = OtherPokemonSpritesModel(
    officialArtwork: tOfficialArtworkSpritesModel,
  );

  test(
    'should be a subclass of OtherPokemonSprites entity',
    () async {
      // assert
      expect(tOtherPokemonSpritesModel, isA<OtherPokemonSprites>());
    },
  );

  group('officialArtwork', () {
    test(
      'should return a OfficialArtworkSpritesModel',
      () async {
        // assert
        expect(
          tOtherPokemonSpritesModel.officialArtwork,
          isA<OfficialArtworkSpritesModel>(),
        );
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
          "official-artwork": tOfficialArtworkSpritesModel.toJson(),
        };

        expect(result, expectedMap);
      },
    );
  });
}
