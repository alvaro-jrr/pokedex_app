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
import 'package:pokedex_app/features/pokemon/presentation/bloc/favorites_bloc.dart';
import 'package:pokedex_app/features/pokemon/presentation/bloc/pokemon_bloc.dart';

@GenerateNiceMocks([MockSpec<GetFavoritePokemons>()])
import 'favorites_bloc_test.mocks.dart';

void main() {
  late MockGetFavoritePokemons mockGetFavoritePokemons;
  late FavoritesBloc bloc;

  setUp(() {
    mockGetFavoritePokemons = MockGetFavoritePokemons();
    bloc = FavoritesBloc(getFavoritePokemons: mockGetFavoritePokemons);
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
}
