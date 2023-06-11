import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/error/failures.dart';
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
])
import 'pokemon_notifier_test.mocks.dart';

void main() {
  late MockGetFavoritePokemons mockGetFavoritePokemons;
  late MockRemoveFavoritePokemon mockRemoveFavoritePokemon;
  late MockAddFavoritePokemon mockAddFavoritePokemon;
  late MockGetConcretePokemon mockGetConcretePokemon;
  late PokemonsNotifier pokemonsNotifier;

  setUp(() {
    mockAddFavoritePokemon = MockAddFavoritePokemon();
    mockRemoveFavoritePokemon = MockRemoveFavoritePokemon();
    mockGetConcretePokemon = MockGetConcretePokemon();
    mockGetFavoritePokemons = MockGetFavoritePokemons();

    pokemonsNotifier = PokemonsNotifier(
      addFavoritePokemon: mockAddFavoritePokemon,
      getConcretePokemon: mockGetConcretePokemon,
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

  group('initial state', () {
    test(
      'currentPokemon should be null',
      () async {
        expect(pokemonsNotifier.currentPokemon, null);
      },
    );
  });

  group('addPokemon', () {
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

    test(
      '''should set the current pokemon as favorite and error 
      must be empty when data is added successfully''',
      () async {
        // arrange
        when(mockAddFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tFavoritePokemon));

        // act
        await pokemonsNotifier.addPokemon(tPokemon);

        // assert
        expect(
          pokemonsNotifier.currentPokemon,
          tFavoritePokemon,
        );

        expect(pokemonsNotifier.error.isEmpty, true);
      },
    );

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

    test(
      '''should update the current pokemon and error must be 
      empty when data is removed successfully''',
      () async {
        // arrange
        when(mockRemoveFavoritePokemon(any))
            .thenAnswer((_) async => const Right(tPokemon));

        // act
        await pokemonsNotifier.removePokemon(tFavoritePokemon.id);

        // assert
        expect(
          pokemonsNotifier.currentPokemon,
          tPokemon,
        );

        expect(pokemonsNotifier.error.isEmpty, true);
      },
    );

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
}
