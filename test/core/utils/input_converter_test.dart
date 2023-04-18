import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('nonEmptyString', () {
    test(
      'should return a non empty string when the string is not empty',
      () async {
        // arrange
        const str = 'Test';

        // act
        final result = inputConverter.nonEmptyString(str);

        // assert
        expect(result, const Right(str));
      },
    );

    test(
      'should return a Failure when the string is empty',
      () async {
        // arrange
        const str = '';

        // act
        final result = inputConverter.nonEmptyString(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });

  group('toSearchQuery', () {
    test(
      'should lowercase the string',
      () async {
        // arrange
        const str = 'TEST';

        // act
        final result = inputConverter.toSearchQuery(str);

        // assert
        expect(result, 'test');
      },
    );

    test(
      'should trim the string',
      () async {
        // arrange
        const str = '   test   ';

        // act
        final result = inputConverter.toSearchQuery(str);

        // assert
        expect(result, 'test');
      },
    );

    test(
      'should convert spaces into hyphens (-)',
      () async {
        // arrange
        const str = 'test 1';

        // act
        final result = inputConverter.toSearchQuery(str);

        // assert
        expect(result, 'test-1');
      },
    );

    test(
      'should encode the string for URLs',
      () async {
        // arrange
        const str = 'test:1';

        // act
        final result = inputConverter.toSearchQuery(str);

        // assert
        expect(result, 'test%3A1');
      },
    );
  });
}
