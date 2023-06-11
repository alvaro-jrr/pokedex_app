import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/with_bloc/bloc/favorites_bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/with_bloc/bloc/pokemon_bloc.dart';

@GenerateNiceMocks([
  MockSpec<GetFavoritePokemons>(),
  MockSpec<RemoveFavoritePokemon>(),
])
import 'favorites_bloc_test.mocks.dart';

void main() {
  late MockGetFavoritePokemons mockGetFavoritePokemons;
  late MockRemoveFavoritePokemon mockRemoveFavoritePokemon;
  late FavoritesBloc bloc;

  setUp(() {
    mockGetFavoritePokemons = MockGetFavoritePokemons();
    mockRemoveFavoritePokemon = MockRemoveFavoritePokemon();

    bloc = FavoritesBloc(
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

  group('GetPokemonsFromFavorites', () {
    test(
      'should get data from the getFavoritePokemons use case',
      () async {
        // arrange
        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => const Right(tPokemonList));

        // act
        bloc.add(const GetPokemonsFromFavorites());
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
        bloc.add(const GetPokemonsFromFavorites());
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
        bloc.add(const GetPokemonsFromFavorites());
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
        bloc.add(const GetPokemonsFromFavorites());
      },
    );
  });
  group('RemoveFavoriteFromFavorites', () {
    const tId = 1;

    final tPokemonListUpdated =
        tPokemonList.where((element) => element.id != tId).toList();

    test(
      'should remove the pokemon with the use case',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // act
        bloc.add(
          const RemoveFavoriteFromFavorites(id: tId, pokemons: tPokemonList),
        );
        await untilCalled(mockRemoveFavoritePokemon(any));

        // assert
        verify(mockRemoveFavoritePokemon(
          const RemoveFavoritePokemonParams(id: tId),
        ));
      },
    );

    test(
      '''should emit [LoadedFavorites] when data is 
      removed successfully without the pokemon removed 
      and set the pokemon as last removed''',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // assert later
        final expected = [
          LoadedFavorites(
            pokemons: tPokemonListUpdated,
            lastRemovedPokemon: tPokemon,
          ),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(
          const RemoveFavoriteFromFavorites(
            id: tId,
            pokemons: tPokemonList,
          ),
        );
      },
    );

    test(
      'should emit [ErrorFavorites] when removing data fails',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          const ErrorFavorites(message: serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(
          const RemoveFavoriteFromFavorites(
            id: tId,
            pokemons: tPokemonList,
          ),
        );
      },
    );

    test(
      'should emit [ErrorFavorites] with a proper message for the error',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          const ErrorFavorites(message: cacheFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(
          const RemoveFavoriteFromFavorites(
            id: tId,
            pokemons: tPokemonList,
          ),
        );
      },
    );
  });
}
