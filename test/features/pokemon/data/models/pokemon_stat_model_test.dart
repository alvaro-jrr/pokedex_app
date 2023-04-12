import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/pokemon_stat_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/stat_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tBaseStat = 1;
  const tStatModel = StatModel(name: 'Test');
  const tPokemonStatModel =
      PokemonStatModel(baseStat: tBaseStat, stat: tStatModel);

  test(
    'should be a subclass of PokemonStat entity',
    () async {
      // assert
      expect(tPokemonStatModel, isA<PokemonStat>());
    },
  );

  group('stat', () {
    test(
      'should return a StatModel',
      () async {
        // assert
        expect(tPokemonStatModel.stat, isA<StatModel>());
      },
    );
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('pokemon_stat.json'));

        // act
        final result = PokemonStatModel.fromJson(jsonMap);

        // assert
        expect(result, tPokemonStatModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tPokemonStatModel.toJson();

        // assert
        final expectedMap = {
          "base_stat": tBaseStat,
          "stat": tStatModel.toJson(),
        };

        expect(result, expectedMap);
      },
    );
  });
}
