import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/core/use_cases/use_case.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/home.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemons.dart';

@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'get_favorite_pokemons_test.mocks.dart';

void main() {
  late MockPokemonRepository mockPokemonRepository;
  late GetFavoritePokemons useCase;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    useCase = GetFavoritePokemons(mockPokemonRepository);
  });

  const tPokemonList = [
    Pokemon(
      id: 1,
      name: 'Test',
      height: 1,
      weight: 1,
      stats: [],
      types: [],
      sprites: PokemonSprites(
        other: OtherPokemonSprites(
          home: Home(frontDefault: ''),
        ),
      ),
    ),
  ];

  test(
    'should get the list of pokemon favorites from the repository',
    () async {
      // arrange
      when(mockPokemonRepository.getFavoritePokemons())
          .thenAnswer((_) async => const Right(tPokemonList));

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, const Right(tPokemonList));
      verify(mockPokemonRepository.getFavoritePokemons());
      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
