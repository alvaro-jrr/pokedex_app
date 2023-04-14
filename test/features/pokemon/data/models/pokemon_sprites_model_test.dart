import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/other_pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tOtherPokemonSpritesModel = OtherPokemonSpritesModel(
    officialArtwork: OfficialArtworkSprites(frontDefault: 'Test'),
  );

  const tPokemonSpritesModel = PokemonSpritesModel(
    other: tOtherPokemonSpritesModel,
  );

  test(
    'should be a subclass of PokemonSprites entity',
    () async {
      // assert
      expect(tPokemonSpritesModel, isA<PokemonSprites>());
    },
  );

  group('other', () {
    test(
      'should return a OtherPokemonSpritesModel ',
      () async {
        // assert
        expect(tPokemonSpritesModel.other, isA<OtherPokemonSpritesModel>());
      },
    );
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('pokemon_sprites.json'));

        // act
        final result = PokemonSpritesModel.fromJson(jsonMap);

        // assert
        expect(result, tPokemonSpritesModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tPokemonSpritesModel.toJson();

        // assert
        final expectedMap = {
          "other": tOtherPokemonSpritesModel.toJson(),
        };

        expect(result, expectedMap);
      },
    );
  });
}
