import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/features/pokemon/data/models/type_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tTypeModel = TypeModel(name: 'Test');

  test(
    'should be a subclass of Type entity',
    () async {
      // assert
      expect(tTypeModel, isA<Type>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('type.json'));

        // act
        final result = TypeModel.fromJson(jsonMap);

        // assert
        expect(result, tTypeModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tTypeModel.toJson();

        // assert
        final expectedMap = {
          "name": "Test",
        };

        expect(result, expectedMap);
      },
    );
  });
}
