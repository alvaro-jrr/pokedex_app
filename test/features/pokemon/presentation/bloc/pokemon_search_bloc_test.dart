import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/utils/constants.dart';
import 'package:pokedex_app/core/utils/input_converter.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_concrete_pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/bloc/bloc.dart';

@GenerateNiceMocks([
  MockSpec<GetConcretePokemon>(),
  MockSpec<InputConverter>(),
])
import 'pokemon_search_bloc_test.mocks.dart';

void main() {
  late PokemonSearchBloc bloc;
  late MockGetConcretePokemon mockGetConcretePokemon;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcretePokemon = MockGetConcretePokemon();
    mockInputConverter = MockInputConverter();

    bloc = PokemonSearchBloc(
      getConcretePokemon: mockGetConcretePokemon,
      inputConverter: mockInputConverter,
    );
  });

  test(
    'initial state should be EmptySearch',
    () async {
      // assert
      expect(bloc.state, EmptySearch());
    },
  );

  group('GetPokemonForConcreteQuery', () {
    const tQuery = 'Test';

    const tPokemon = Pokemon(
      id: 1,
      name: 'Test',
      height: 1,
      weight: 1,
      stats: [],
      types: [],
      sprites: PokemonSprites(
        other: OtherPokemonSprites(
          officialArtwork: OfficialArtworkSprites(frontDefault: ''),
        ),
      ),
      isFavorite: true,
    );

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.nonEmptyString(any))
          .thenAnswer((_) => const Right(tQuery));
    }

    test(
      'should call the InputConverter to validate the query',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
        await untilCalled(mockInputConverter.nonEmptyString(any));

        // assert
        verify(mockInputConverter.nonEmptyString(tQuery));
      },
    );

    test(
      'should emit [ErrorSearch] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.nonEmptyString(any))
            .thenAnswer((_) => Left(InvalidInputFailure()));

        // assert later
        const expected = [
          ErrorSearch(message: invalidInputMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
        await untilCalled(mockGetConcretePokemon(any));

        // assert
        verify(
          mockGetConcretePokemon(const GetConcretePokemonParams(query: tQuery)),
        );
      },
    );

    test(
      'should emit [LoadingSearch, LoadedSearch] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          LoadingSearch(),
          const LoadedSearch(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
      },
    );

    test(
      'should emit [LoadingSearch, ErrorSearch] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingSearch(),
          const ErrorSearch(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
      },
    );

    test(
      'should emit [LoadingSearch, ErrorSearch] with a proper message for the error',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          LoadingSearch(),
          const ErrorSearch(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
      },
    );
  });
}
