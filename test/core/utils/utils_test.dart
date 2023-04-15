import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/core/utils/utils.dart';

void main() {
  group('toTitleCase', () {
    test(
      'first character should be in uppercase',
      () async {
        // arrange
        const str = 'abc';

        // act
        final result = toTitleCase(str);

        // assert
        expect(result.characters.first, 'A');
      },
    );

    test(
      'every character after first character should be in lowercase',
      () async {
        // arrange
        const str = 'abc';

        // act
        final result = toTitleCase(str);

        // assert
        expect(result, 'Abc');
      },
    );

    test(
      'should return an empty string when the string is empty',
      () async {
        // arrange
        const str = '';

        // act
        final result = toTitleCase(str);

        // assert
        expect(result, '');
      },
    );

    test(
      'should return only the first character if string length is 1',
      () async {
        // arrange
        const str = 'a';

        // act
        final result = toTitleCase(str);

        // assert
        expect(result, 'A');
      },
    );
  });
}
