import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/stat_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/stat.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tStatModel = StatModel(name: 'Test');

  test(
    'should be a subclass of Stat entity',
    () async {
      // assert
      expect(tStatModel, isA<Stat>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('stat.json'));

        // act
        final result = StatModel.fromJson(jsonMap);

        // assert
        expect(result, tStatModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tStatModel.toJson();

        // assert
        final expectedMap = {
          "name": "Test",
        };

        expect(result, expectedMap);
      },
    );
  });
}
