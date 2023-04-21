import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/utils/input_converter.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/add_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_concrete_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/bloc/pokemon_bloc.dart';

@GenerateNiceMocks([
  MockSpec<AddFavoritePokemon>(),
  MockSpec<GetFavoritePokemons>(),
  MockSpec<RemoveFavoritePokemon>(),
  MockSpec<GetConcretePokemon>(),
  MockSpec<InputConverter>(),
])
import 'pokemon_bloc_test.mocks.dart';

void main() {
  late MockAddFavoritePokemon mockAddFavoritePokemon;
  late MockRemoveFavoritePokemon mockRemoveFavoritePokemon;
  late MockGetConcretePokemon mockGetConcretePokemon;
  late MockInputConverter mockInputConverter;
  late PokemonBloc bloc;

  setUp(() {
    mockAddFavoritePokemon = MockAddFavoritePokemon();
    mockRemoveFavoritePokemon = MockRemoveFavoritePokemon();
    mockGetConcretePokemon = MockGetConcretePokemon();
    mockInputConverter = MockInputConverter();

    bloc = PokemonBloc(
      addFavoritePokemon: mockAddFavoritePokemon,
      removeFavoritePokemon: mockRemoveFavoritePokemon,
      getConcretePokemon: mockGetConcretePokemon,
      inputConverter: mockInputConverter,
    );
  });

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

  test(
    'initial state should be Empty',
    () async {
      // assert
      expect(bloc.state, Empty());
    },
  );

  group('AddPokemonToFavorites', () {
    test(
      'should add the pokemon with the use case',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // act
        bloc.add(const AddPokemonToFavorites(tPokemon));
        await untilCalled(mockAddFavoritePokemon(any));

        // assert
        verify(mockAddFavoritePokemon(
          const AddFavoritePokemonParams(pokemon: tPokemon),
        ));
      },
    );

    test(
      'should emit [LoadedPokemon] when data is added successfully',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          const LoadedPokemon(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const AddPokemonToFavorites(tPokemon));
      },
    );

    test(
      'should emit [Error] when adding data fails',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const AddPokemonToFavorites(tPokemon));
      },
    );

    test(
      'should emit [Error] with a proper message for the error',
      () async {
        // arrange

        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const AddPokemonToFavorites(tPokemon));
      },
    );
  });

  group('RemovePokemonFromFavorites', () {
    const tId = 1;

    test(
      'should remove the pokemon with the use case',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
        await untilCalled(mockRemoveFavoritePokemon(any));

        // assert
        verify(mockRemoveFavoritePokemon(
          const RemoveFavoritePokemonParams(id: tId),
        ));
      },
    );

    test(
      'should emit [LoadedPokemon] when data is removed successfully',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          const LoadedPokemon(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
      },
    );

    test(
      'should emit [Error] when removing data fails',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
      },
    );

    test(
      'should emit [Error] with a proper message for the error',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
      },
    );
  });

  group('GetPokemonForConcreteQuery', () {
    const tQuery = 'Test';
    const tQueryParsed = 'test';

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.nonEmptyString(any))
          .thenAnswer((_) => const Right(tQuery));
    }

    void setUpSucessfullCall() {
      setUpMockInputConverterSuccess();

      when(mockInputConverter.toSearchQuery(any)).thenReturn(tQueryParsed);

      when(mockGetConcretePokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));
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
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.nonEmptyString(any))
            .thenAnswer((_) => Left(InvalidInputFailure()));

        // assert later
        const expected = [
          Error(message: invalidInputMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
      },
    );

    test(
      'should convert the string with toSearchQuery method',
      () async {
        // arrange
        setUpSucessfullCall();

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
        await untilCalled(mockInputConverter.toSearchQuery(any));

        // assert
        verify(mockInputConverter.toSearchQuery(tQuery));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpSucessfullCall();

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
        await untilCalled(mockGetConcretePokemon(any));

        // assert
        verify(
          mockGetConcretePokemon(
            const GetConcretePokemonParams(query: tQueryParsed),
          ),
        );
      },
    );

    test(
      'should emit [Loading, LoadedPokemon] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          Loading(),
          const LoadedPokemon(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
      },
    );

    test(
      'should emit [Loading, ErrorSearch] with a proper message for the error',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetPokemonForConcreteQuery(tQuery));
      },
    );
  });

  group('SetConcretePokemon', () {
    test(
      'should emit [LoadedPokemon] with the passed pokemon',
      () async {
        // assert later
        final expected = [
          const LoadedPokemon(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const SetConcretePokemon(tPokemon));
      },
    );
  });
}
