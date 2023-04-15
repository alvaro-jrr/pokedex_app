import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
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
  late MockGetFavoritePokemons mockGetFavoritePokemons;
  late MockRemoveFavoritePokemon mockRemoveFavoritePokemon;
  late MockGetConcretePokemon mockGetConcretePokemon;
  late MockInputConverter mockInputConverter;
  late PokemonBloc bloc;

  setUp(() {
    mockAddFavoritePokemon = MockAddFavoritePokemon();
    mockGetFavoritePokemons = MockGetFavoritePokemons();
    mockRemoveFavoritePokemon = MockRemoveFavoritePokemon();
    mockGetConcretePokemon = MockGetConcretePokemon();
    mockInputConverter = MockInputConverter();

    bloc = PokemonBloc(
      addFavoritePokemon: mockAddFavoritePokemon,
      getFavoritePokemons: mockGetFavoritePokemons,
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

  const tPokemonList = [tPokemon];

  test(
    'initial state should be Empty',
    () async {
      // assert
      expect(bloc.state, Empty());
    },
  );

  group('GetPokemonsFromFavorites', () {
    test(
      'should get data from the getFavoritePokemons use case',
      () async {
        // arrange
        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => const Right(tPokemonList));

        // act
        bloc.add(GetPokemonsFromFavorites());
        await untilCalled(mockGetFavoritePokemons(any));

        // assert
        verify(mockGetFavoritePokemons(NoParams()));
      },
    );

    test(
      'should emit [Loading, LoadedFavorites] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => const Right(tPokemonList));

        // assert later
        final expected = [
          Loading(),
          const LoadedFavorites(pokemons: tPokemonList),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetPokemonsFromFavorites());
      },
    );

    test(
      'should emit [Loading, ErrorFavorites] when getting data fails',
      () async {
        // arrange
        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetPokemonsFromFavorites());
      },
    );

    test(
      'should emit [Loading, ErrorFavorites] with a proper message for the error',
      () async {
        // arrange

        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetPokemonsFromFavorites());
      },
    );
  });

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
      'should emit [LoadingFavorite, LoadedPokemon] when data is added successfully',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          LoadingFavorite(),
          const LoadedPokemon(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const AddPokemonToFavorites(tPokemon));
      },
    );

    test(
      'should emit [LoadingFavorite, Error] when adding data fails',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingFavorite(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const AddPokemonToFavorites(tPokemon));
      },
    );

    test(
      'should emit [LoadingFavorite, ErrorFavorites] with a proper message for the error',
      () async {
        // arrange

        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          LoadingFavorite(),
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
      'should emit [LoadingFavorite, LoadedPokemon] when data is removed successfully',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          LoadingFavorite(),
          const LoadedPokemon(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
      },
    );

    test(
      'should emit [LoadingFavorite, Error] when removing data fails',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingFavorite(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
      },
    );

    test(
      'should emit [LoadingFavorite, Error] with a proper message for the error',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          LoadingFavorite(),
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
}
