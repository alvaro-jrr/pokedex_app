import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'package:pokedex_app/core/databases/pokemon_database.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/features/pokemon/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/home_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_type.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

@GenerateNiceMocks([MockSpec<PokemonDatabase>()])
import 'pokemon_local_data_source_test.mocks.dart';

void main() {
  late MockPokemonDatabase mockPokemonDatabase;
  late PokemonLocalDataSourceImpl dataSourceImpl;

  setUp(() {
    mockPokemonDatabase = MockPokemonDatabase();
    dataSourceImpl = PokemonLocalDataSourceImpl(database: mockPokemonDatabase);
  });

  const tId = 1;

  const tPokemonModel = PokemonModel(
    id: 1,
    name: 'Test',
    height: 1,
    weight: 1,
    sprites: PokemonSprites(
      other: OtherPokemonSprites(home: HomeSprites(frontDefault: 'Test')),
    ),
    stats: [
      PokemonStat(baseStat: 1, stat: Stat(name: 'Test')),
    ],
    types: [
      PokemonType(slot: 1, type: Type(name: 'Test')),
    ],
  );

  const tPokemonModels = [tPokemonModel];

  group('getFavoritePokemonById', () {
    test(
      'should get pokemon with id from the database',
      () async {
        // arrange
        when(mockPokemonDatabase.getPokemonById(any))
            .thenAnswer((_) async => tPokemonModel);

        // act
        final result = await dataSourceImpl.getFavoritePokemonById(tId);

        // assert
        expect(result, tPokemonModel);
        verify(mockPokemonDatabase.getPokemonById(tId));
      },
    );

    test(
      'should throw a CacheException when pokemon not found',
      () async {
        // arrange
        when(mockPokemonDatabase.getPokemonById(any))
            .thenAnswer((_) async => null);

        // act
        final call = dataSourceImpl.getFavoritePokemonById;

        // assert
        expect(() => call(tId), throwsA(const TypeMatcher<CacheException>()));
      },
    );

    test(
      'should throw a CacheException when an error ocurrs in the database',
      () async {
        // arrange
        when(mockPokemonDatabase.getPokemonById(any))
            .thenThrow(DatabaseException);

        // act
        final call = dataSourceImpl.getFavoritePokemonById;

        // assert
        expect(() => call(tId), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('getFavoritePokemonByName', () {
    const tName = 'Test';

    test(
      'should get pokemon with name from the database',
      () async {
        // arrange
        when(mockPokemonDatabase.getPokemonByName(any))
            .thenAnswer((_) async => tPokemonModel);

        // act
        final result = await dataSourceImpl.getFavoritePokemonByName(tName);

        // assert
        expect(result, tPokemonModel);
        verify(mockPokemonDatabase.getPokemonByName(tName));
      },
    );

    test(
      'should throw a CacheException when pokemon not found',
      () async {
        // arrange
        when(mockPokemonDatabase.getPokemonByName(any))
            .thenAnswer((_) async => null);

        // act
        final call = dataSourceImpl.getFavoritePokemonByName;

        // assert
        expect(() => call(tName), throwsA(const TypeMatcher<CacheException>()));
      },
    );

    test(
      'should throw a CacheException when an error ocurrs in the database',
      () async {
        // arrange
        when(mockPokemonDatabase.getPokemonByName(any))
            .thenThrow(DatabaseException);

        // act
        final call = dataSourceImpl.getFavoritePokemonByName;

        // assert
        expect(() => call(tName), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('getFavoritePokemons', () {
    test(
      'should get the pokemons from the database',
      () async {
        // arrange
        when(mockPokemonDatabase.getPokemons())
            .thenAnswer((_) async => tPokemonModels);

        // act
        final result = await dataSourceImpl.getFavoritePokemons();

        // assert
        expect(result, tPokemonModels);
        verify(mockPokemonDatabase.getPokemons());
      },
    );

    test(
      'should throw a CacheException when an error ocurrs in the database',
      () async {
        // arrange
        when(mockPokemonDatabase.getPokemons()).thenThrow(DatabaseException);

        // act
        final call = dataSourceImpl.getFavoritePokemons;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('addFavoritePokemon', () {
    test(
      'should store the pokemon in the database',
      () async {
        // arrange
        when(mockPokemonDatabase.newPokemon(any)).thenAnswer((_) async => tId);

        // act
        dataSourceImpl.addFavoritePokemon(tPokemonModel);

        // assert
        verify(mockPokemonDatabase.newPokemon(tPokemonModel));
      },
    );

    test(
      'should throw a CacheException when an error ocurrs in the database',
      () async {
        // arrange
        when(mockPokemonDatabase.newPokemon(any)).thenThrow(DatabaseException);

        // act
        final call = dataSourceImpl.addFavoritePokemon;

        // assert
        expect(() => call(tPokemonModel),
            throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('removeFavoritePokemon', () {
    const tRows = 1;

    test(
      'should remove the pokemon in the database',
      () async {
        // arrange
        when(mockPokemonDatabase.deletePokemon(any))
            .thenAnswer((_) async => tRows);

        // act
        dataSourceImpl.removeFavoritePokemon(tId);

        // assert
        verify(mockPokemonDatabase.deletePokemon(tId));
      },
    );

    test(
      'should throw a CacheException when an error ocurrs in the database',
      () async {
        // arrange
        when(mockPokemonDatabase.deletePokemon(any))
            .thenThrow(DatabaseException);

        // act
        final call = dataSourceImpl.removeFavoritePokemon;

        // assert
        expect(
          () => call(tId),
          throwsA(const TypeMatcher<CacheException>()),
        );
      },
    );
  });
}
