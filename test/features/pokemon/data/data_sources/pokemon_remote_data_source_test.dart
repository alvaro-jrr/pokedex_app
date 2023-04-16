import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_type.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

import '../../../../fixtures/fixture_reader.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'pokemon_remote_data_source_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late PokemonRemoteDataSourceImpl dataSourceImpl;

  setUp(() {
    mockClient = MockClient();
    dataSourceImpl = PokemonRemoteDataSourceImpl(client: mockClient);
  });

  const tPokemonModel = PokemonModel(
    id: 1,
    name: 'Test',
    height: 1,
    weight: 1,
    sprites: PokemonSprites(
      other: OtherPokemonSprites(
        officialArtwork: OfficialArtworkSprites(frontDefault: 'Test'),
      ),
    ),
    stats: [
      PokemonStat(baseStat: 1, stat: Stat(name: 'Test')),
    ],
    types: [
      PokemonType(slot: 1, type: Type(name: 'Test')),
    ],
  );

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('pokemon.json'), 200));
  }

  void setUpMockHttpClientError404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Not Found', 404));
  }

  void setUpMockHttpClientGeneralError() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Server Error', 500));
  }

  group('getConcretePokemon', () {
    const tQuery = 'Test 1';

    test(
      '''should perform a GET request on a URL with the encoded query
      being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        dataSourceImpl.getConcretePokemon(tQuery);

        // assert
        verify(
          mockClient.get(
            Uri.https(
              'pokeapi.co',
              '/api/v2/pokemon/${Uri.encodeComponent(tQuery)}',
            ),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return PokemonModel when status code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSourceImpl.getConcretePokemon(tQuery);

        // assert
        expect(result, tPokemonModel);
      },
    );

    test(
      'should throw a ServerException when the status code is 404',
      () async {
        // arrange
        setUpMockHttpClientError404();

        // act
        final call = dataSourceImpl.getConcretePokemon;

        // assert
        expect(
          () => call(tQuery),
          throwsA(const TypeMatcher<NotFoundException>()),
        );
      },
    );

    test(
      'should throw a ServerException when the status code is other than 404',
      () async {
        // arrange
        setUpMockHttpClientGeneralError();

        // act
        final call = dataSourceImpl.getConcretePokemon;

        // assert
        expect(
          () => call(tQuery),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );

    test(
      'should throw a ServerException when the call throws a ClientException',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers')))
            .thenThrow(http.ClientException(''));

        // act
        final call = dataSourceImpl.getConcretePokemon;

        // assert
        expect(
          () => call(tQuery),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
