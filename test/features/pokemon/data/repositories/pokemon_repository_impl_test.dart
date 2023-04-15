import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_type.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

@GenerateNiceMocks([
  MockSpec<PokemonRemoteDataSource>(),
  MockSpec<PokemonLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
import 'pokemon_repository_impl_test.mocks.dart';

void main() {
  late MockPokemonRemoteDataSource mockPokemonRemoteDataSource;
  late MockPokemonLocalDataSource mockPokemonLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late PokemonRepositoryImpl repository;

  setUp(() {
    mockPokemonRemoteDataSource = MockPokemonRemoteDataSource();
    mockPokemonLocalDataSource = MockPokemonLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = PokemonRepositoryImpl(
      localDataSource: mockPokemonLocalDataSource,
      remoteDataSource: mockPokemonRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
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

  final tNotFavoritePokemonModel = tPokemonModel.copyWith(isFavorite: false);

  final tFavoritePokemonModel = tPokemonModel.copyWith(isFavorite: true);

  const Pokemon tPokemon = tPokemonModel;

  group('getConcretePokemon', () {
    const tQuery = 'Test';
    const tId = 1;
    const tIdQuery = '1';

    test(
      'should search the pokemon locally first',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.getFavoritePokemonByName(any))
            .thenAnswer((_) async => tPokemonModel);

        // act
        final result = await repository.getConcretePokemon(tQuery);

        // assert
        expect(result, const Right(tPokemonModel));
        verify(mockPokemonLocalDataSource.getFavoritePokemonByName(tQuery));
        verifyZeroInteractions(mockPokemonRemoteDataSource);
      },
    );

    test(
      'should call proper method to get pokemon locally according to query type',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.getFavoritePokemonById(any))
            .thenAnswer((_) async => tPokemonModel);

        // act
        final result = await repository.getConcretePokemon(tIdQuery);

        // assert
        expect(result, const Right(tPokemonModel));
        verify(mockPokemonLocalDataSource.getFavoritePokemonById(tId));
        verifyZeroInteractions(mockPokemonRemoteDataSource);
      },
    );

    group('pokemon not found locally', () {
      setUp(() {
        when(mockPokemonLocalDataSource.getFavoritePokemonByName(any))
            .thenThrow(CacheException());
      });

      test(
        'should check if the device is online',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          // act
          repository.getConcretePokemon(tQuery);

          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );

      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            // arrange
            when(mockPokemonRemoteDataSource.getConcretePokemon(any))
                .thenAnswer((_) async => tPokemonModel);

            // act
            final result = await repository.getConcretePokemon(tQuery);

            // assert
            verify(mockPokemonRemoteDataSource.getConcretePokemon(tQuery));
            expect(result, const Right(tPokemon));
          },
        );

        test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
            // arrange
            when(mockPokemonRemoteDataSource.getConcretePokemon(any))
                .thenThrow(ServerException());

            // act
            final result = await repository.getConcretePokemon(tQuery);

            // assert
            verify(mockPokemonRemoteDataSource.getConcretePokemon(tQuery));
            expect(result, Left(ServerFailure()));
          },
        );
      });

      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test(
          'should return ServerFailure when device is offline',
          () async {
            // act
            final result = await repository.getConcretePokemon(tQuery);

            // assert
            verifyZeroInteractions(mockPokemonRemoteDataSource);
            expect(result, Left(ServerFailure()));
          },
        );
      });
    });
  });

  group('getFavoritePokemon', () {
    const tId = 1;

    test(
      'should return pokemon when id is present',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.getFavoritePokemonById(any))
            .thenAnswer((_) async => tPokemonModel);

        // act
        final result = await repository.getFavoritePokemon(tId);

        // assert
        verify(mockPokemonLocalDataSource.getFavoritePokemonById(tId));
        expect(result, const Right(tPokemon));
      },
    );

    test(
      'should return CacheFailure when pokemon id is not found',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.getFavoritePokemonById(any))
            .thenThrow(CacheException());

        // act
        final result = await repository.getFavoritePokemon(tId);

        // assert
        verify(mockPokemonLocalDataSource.getFavoritePokemonById(tId));
        expect(result, Left(CacheFailure()));
      },
    );
  });

  group('getFavoritePokemons', () {
    const tPokemonModels = [tPokemonModel];
    const List<Pokemon> tPokemons = tPokemonModels;

    test(
      'should return pokemon list when data is gotten successfully',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.getFavoritePokemons())
            .thenAnswer((_) async => tPokemonModels);

        // act
        final result = await repository.getFavoritePokemons();

        // assert
        verify(mockPokemonLocalDataSource.getFavoritePokemons());
        expect(result, const Right(tPokemons));
      },
    );

    test(
      'should return CacheFailure when data is not gotten successfully',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.getFavoritePokemons())
            .thenThrow(CacheException());

        // act
        final result = await repository.getFavoritePokemons();

        // assert
        verify(mockPokemonLocalDataSource.getFavoritePokemons());
        expect(result, Left(CacheFailure()));
      },
    );
  });

  group('addFavoritePokemon', () {
    test(
      'should pass a PokemonModel',
      () async {
        // act
        await repository.addFavoritePokemon(tPokemon);

        // assert
        verify(mockPokemonLocalDataSource.addFavoritePokemon(tPokemonModel));
      },
    );

    test(
      'should add a pokemon as favorite',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.addFavoritePokemon(any))
            .thenAnswer((_) async => tFavoritePokemonModel);

        // act
        final result = await repository.addFavoritePokemon(tPokemon);

        // assert
        verify(mockPokemonLocalDataSource.addFavoritePokemon(tPokemonModel));
        expect(result, Right(tFavoritePokemonModel));
      },
    );

    test(
      'should return a CacheFailure if pokemon is not added successfully',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.addFavoritePokemon(any))
            .thenThrow(CacheException());

        // act
        final result = await repository.addFavoritePokemon(tPokemon);

        // assert
        verify(mockPokemonLocalDataSource.addFavoritePokemon(tPokemonModel));
        expect(result, Left(CacheFailure()));
      },
    );
  });

  group('removeFavoritePokemon', () {
    const tId = 1;

    test(
      'should remove the pokemon when id is found',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.removeFavoritePokemon(any))
            .thenAnswer((_) async => tNotFavoritePokemonModel);

        // act
        final result = await repository.removeFavoritePokemon(tId);

        // assert
        verify(mockPokemonLocalDataSource.removeFavoritePokemon(tId));
        expect(result, Right(tNotFavoritePokemonModel));
      },
    );

    test(
      'should return a CacheFailure when id is not found',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.removeFavoritePokemon(any))
            .thenThrow(CacheException());

        // act
        final result = await repository.removeFavoritePokemon(tId);

        // assert
        expect(result, Left(CacheFailure()));
        verify(mockPokemonLocalDataSource.removeFavoritePokemon(tId));
      },
    );
  });
}
