import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/core/utils/input_converter.dart';
import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/add_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_concrete_pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';
import 'package:pokedex_app/features/pokemon/presentation/with_provider/notifiers/pokemon_notifier.dart';

@GenerateNiceMocks([
  MockSpec<AddFavoritePokemon>(),
  MockSpec<GetFavoritePokemons>(),
  MockSpec<GetConcretePokemon>(),
  MockSpec<RemoveFavoritePokemon>(),
  MockSpec<InputConverter>()
])
import 'pokemon_notifier_test.mocks.dart';

void main() {
  late MockGetFavoritePokemons mockGetFavoritePokemons;
  late MockRemoveFavoritePokemon mockRemoveFavoritePokemon;
  late MockAddFavoritePokemon mockAddFavoritePokemon;
  late MockGetConcretePokemon mockGetConcretePokemon;
  late MockInputConverter mockInputConverter;
  late PokemonsNotifier pokemonsNotifier;

  setUp(() {
    mockAddFavoritePokemon = MockAddFavoritePokemon();
    mockRemoveFavoritePokemon = MockRemoveFavoritePokemon();
    mockGetConcretePokemon = MockGetConcretePokemon();
    mockGetFavoritePokemons = MockGetFavoritePokemons();
    mockInputConverter = MockInputConverter();

    pokemonsNotifier = PokemonsNotifier(
      addFavoritePokemon: mockAddFavoritePokemon,
      getConcretePokemon: mockGetConcretePokemon,
      getFavoritePokemons: mockGetFavoritePokemons,
      removeFavoritePokemon: mockRemoveFavoritePokemon,
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
    isFavorite: false,
  );

  const tFavoritePokemon = Pokemon(
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

  const tFavorites = [tFavoritePokemon];

  group('initial state', () {
    test(
      'currentPokemon should be null',
      () async {
        expect(pokemonsNotifier.currentPokemon, null);
      },
    );

    test(
      'favoritePokemons should be empty',
      () async {
        expect(pokemonsNotifier.favoritePokemons.isEmpty, true);
      },
    );
  });

  group('addPokemon', () {
    void setUpAddPokemonSuccessful() {
      when(mockAddFavoritePokemon(any))
          .thenAnswer((_) async => const Right(tFavoritePokemon));
    }

    test(
      'should add the pokemon with the use case',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // act
        await pokemonsNotifier.addPokemon(tPokemon);

        // assert
        verify(mockAddFavoritePokemon(
          const AddFavoritePokemonParams(pokemon: tPokemon),
        ));
      },
    );

    group('added pokemon successfully', () {
      test(
        'should set the current pokemon as favorite',
        () async {
          // arrange
          setUpAddPokemonSuccessful();

          // act
          await pokemonsNotifier.addPokemon(tPokemon);

          // assert
          expect(
            pokemonsNotifier.currentPokemon,
            tFavoritePokemon,
          );
        },
      );

      test(
        'should be empty the error message',
        () async {
          // arrange
          setUpAddPokemonSuccessful();

          // act
          await pokemonsNotifier.addPokemon(tPokemon);

          // assert
          expect(pokemonsNotifier.error.isEmpty, true);
        },
      );

      test(
        'should be added to favoritesPokemon list',
        () async {
          // arrange
          setUpAddPokemonSuccessful();

          // act
          await pokemonsNotifier.addPokemon(tPokemon);

          // assert
          expect(
            pokemonsNotifier.favoritePokemons.contains(tFavoritePokemon),
            true,
          );
        },
      );
    });

    test(
      'should set the error message when adding data fails',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // act
        await pokemonsNotifier.addPokemon(tPokemon);

        // assert
        expect(pokemonsNotifier.error, mapFailureToMessage(ServerFailure()));
      },
    );
  });

  group('removePokemon', () {
    void setUpRemovePokemonSuccess() {
      when(mockRemoveFavoritePokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));
    }

    test(
      'should remove the pokemon with the use case',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tFavoritePokemon));

        // act
        await pokemonsNotifier.removePokemon(tFavoritePokemon.id);

        // assert
        verify(mockRemoveFavoritePokemon(
          RemoveFavoritePokemonParams(id: tFavoritePokemon.id),
        ));
      },
    );

    group('removed pokemon successfully', () {
      test(
        'should update the current pokemon',
        () async {
          // arrange
          setUpRemovePokemonSuccess();

          // act
          await pokemonsNotifier.removePokemon(tFavoritePokemon.id);

          // assert
          expect(
            pokemonsNotifier.currentPokemon,
            tPokemon,
          );
        },
      );

      test(
        'should be empty the error message',
        () async {
          // arrange
          setUpRemovePokemonSuccess();

          // act
          await pokemonsNotifier.removePokemon(tFavoritePokemon.id);

          // assert
          expect(pokemonsNotifier.error.isEmpty, true);
        },
      );

      test(
        'should be removed from favoritesPokemon list',
        () async {
          // arrange
          setUpRemovePokemonSuccess();

          // act
          await pokemonsNotifier.removePokemon(tFavoritePokemon.id);

          // assert
          expect(
            pokemonsNotifier.favoritePokemons.contains(tFavoritePokemon),
            false,
          );
        },
      );
    });

    test(
      'should set the error message when adding data fails',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // act
        await pokemonsNotifier.removePokemon(tFavoritePokemon.id);

        // assert
        expect(pokemonsNotifier.error, mapFailureToMessage(ServerFailure()));
      },
    );
  });

  group('getPokemon', () {
    const tQuery = 'Test';

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.nonEmptyString(any))
          .thenAnswer((_) => const Right(tQuery));
    }

    void setUpSucessfullCall() {
      setUpMockInputConverterSuccess();

      when(mockInputConverter.toSearchQuery(any)).thenReturn(tQuery);

      when(mockGetConcretePokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));
    }

    test(
      'should call InputConverter to validate the query',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // act
        await pokemonsNotifier.getPokemon(tQuery);

        // assert
        verify(mockInputConverter.nonEmptyString(tQuery));
      },
    );

    test(
      'should set the error message when input is invalid',
      () async {
        // arrange
        when(mockInputConverter.nonEmptyString(any))
            .thenAnswer((_) => Left(InvalidInputFailure()));

        // act
        await pokemonsNotifier.getPokemon(tQuery);

        // assert
        expect(pokemonsNotifier.error.isNotEmpty, true);
      },
    );

    test(
      'should convert the string with toSearchQuery method',
      () async {
        // arrange
        setUpSucessfullCall();

        // act
        await pokemonsNotifier.getPokemon(tQuery);

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
        await pokemonsNotifier.getPokemon(tQuery);

        // assert
        verify(
          mockGetConcretePokemon(
            const GetConcretePokemonParams(query: tQuery),
          ),
        );
      },
    );

    group('got concrete pokemon successfuly', () {
      test(
        'should set as current pokemon',
        () async {
          // arrange
          setUpSucessfullCall();

          // act
          await pokemonsNotifier.getPokemon(tQuery);

          // assert
          expect(pokemonsNotifier.currentPokemon, tPokemon);
        },
      );

      test(
        'should be empty the error message',
        () async {
          // arrange
          setUpSucessfullCall();

          // act
          await pokemonsNotifier.getPokemon(tQuery);

          // assert
          expect(pokemonsNotifier.error.isEmpty, true);
        },
      );
    });

    group('getting pokemon fails', () {
      final tFailure = ServerFailure();

      test(
        'should set the error message',
        () async {
          // arrange
          setUpMockInputConverterSuccess();

          when(mockGetConcretePokemon(any))
              .thenAnswer((_) async => Left(tFailure));

          // act
          await pokemonsNotifier.getPokemon(tQuery);

          // assert
          expect(pokemonsNotifier.error, mapFailureToMessage(tFailure));
        },
      );
    });
  });

  group('getFavorites', () {
    final tFailure = ServerFailure();

    test(
      'should get the pokemons with the use case',
      () async {
        // arrange
        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => const Right(tFavorites));

        // act
        await pokemonsNotifier.getFavorites();

        // assert
        verify(mockGetFavoritePokemons(NoParams()));
      },
    );

    group('data gotten successfuly', () {
      test(
        'should set pokemons as favorites',
        () async {
          // arrange
          when(mockGetFavoritePokemons(any))
              .thenAnswer((_) async => const Right(tFavorites));

          // act
          await pokemonsNotifier.getFavorites();

          // assert
          expect(pokemonsNotifier.favoritePokemons, tFavorites);
        },
      );

      test(
        'should be empty the error message',
        () async {
          // arrange
          when(mockGetFavoritePokemons(any))
              .thenAnswer((_) async => const Right(tFavorites));

          // act
          await pokemonsNotifier.getFavorites();

          // assert
          expect(pokemonsNotifier.error.isEmpty, true);
        },
      );
    });

    test(
      'should set the error message when getting data fails',
      () async {
        // arrange
        when(mockGetFavoritePokemons(any))
            .thenAnswer((_) async => Left(tFailure));

        // act
        await pokemonsNotifier.getFavorites();

        // assert
        expect(pokemonsNotifier.error, mapFailureToMessage(tFailure));
      },
    );
  });
}
