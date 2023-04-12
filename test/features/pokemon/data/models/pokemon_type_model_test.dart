import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/pokemon_type_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/type_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_type.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tSlot = 1;
  const tTypeModel = TypeModel(name: 'Test');
  const tPokemonTypeModel = PokemonTypeModel(
    slot: tSlot,
    type: tTypeModel,
  );

  test(
    'should be a subclass of PokemonType entity',
    () async {
      // assert
      expect(tPokemonTypeModel, isA<PokemonType>());
    },
  );

  group('type', () {
    test(
      'should be return a TypeModel',
      () async {
        // assert
        expect(tPokemonTypeModel.type, isA<TypeModel>());
      },
    );
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('pokemon_type.json'));

        // act
        final result = PokemonTypeModel.fromJson(jsonMap);

        // assert
        expect(result, tPokemonTypeModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tPokemonTypeModel.toJson();

        // assert
        final expectedMap = {
          'slot': tSlot,
          'type': tTypeModel.toJson(),
        };

        expect(result, expectedMap);
      },
    );
  });
}
