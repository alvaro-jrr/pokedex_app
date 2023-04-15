import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/core/utils/constants.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/add_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/bloc/bloc.dart';

@GenerateNiceMocks([
  MockSpec<AddFavoritePokemon>(),
  MockSpec<GetFavoritePokemons>(),
  MockSpec<RemoveFavoritePokemon>(),
])
import 'pokemon_favorites_bloc_test.mocks.dart';

void main() {
  late MockAddFavoritePokemon mockAddFavoritePokemon;
  late MockGetFavoritePokemons mockGetFavoritePokemons;
  late MockRemoveFavoritePokemon mockRemoveFavoritePokemon;
  late PokemonFavoritesBloc bloc;

  setUp(() {
    mockAddFavoritePokemon = MockAddFavoritePokemon();
    mockGetFavoritePokemons = MockGetFavoritePokemons();
    mockRemoveFavoritePokemon = MockRemoveFavoritePokemon();

    bloc = PokemonFavoritesBloc(
      addFavoritePokemon: mockAddFavoritePokemon,
      getFavoritePokemons: mockGetFavoritePokemons,
      removeFavoritePokemon: mockRemoveFavoritePokemon,
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
    'initial state should be EmptyFavorites',
    () async {
      // assert
      expect(bloc.state, EmptyFavorites());
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
      'should emit [LoadingFavorites, LoadedFavorites] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => const Right(tPokemonList));

        // assert later
        final expected = [
          LoadingFavorites(),
          const LoadedFavorites(pokemons: tPokemonList),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetPokemonsFromFavorites());
      },
    );

    test(
      'should emit [LoadingFavorites, ErrorFavorites] when getting data fails',
      () async {
        // arrange
        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingFavorites(),
          const ErrorFavorites(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetPokemonsFromFavorites());
      },
    );

    test(
      'should emit [LoadingFavorites, ErrorFavorites] with a proper message for the error',
      () async {
        // arrange

        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          LoadingFavorites(),
          const ErrorFavorites(message: cacheFailureMessage),
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
      'should emit [LoadingFavorite, LoadedFavorite] when data is added successfully',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          LoadingFavorite(),
          const LoadedFavorite(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const AddPokemonToFavorites(tPokemon));
      },
    );

    test(
      'should emit [LoadingFavorite, ErrorFavorites] when adding data fails',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingFavorite(),
          const ErrorFavorites(message: serverFailureMessage),
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
          const ErrorFavorites(message: cacheFailureMessage),
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
      'should emit [LoadingFavorite, LoadedFavorite] when data is removed successfully',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          LoadingFavorite(),
          const LoadedFavorite(pokemon: tPokemon),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
      },
    );

    test(
      'should emit [LoadingFavorite, ErrorFavorites] when removing data fails',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingFavorite(),
          const ErrorFavorites(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
      },
    );

    test(
      'should emit [LoadingFavorite, ErrorFavorites] with a proper message for the error',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          LoadingFavorite(),
          const ErrorFavorites(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const RemovePokemonFromFavorites(tId));
      },
    );
  });
}
