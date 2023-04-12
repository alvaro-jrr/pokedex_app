import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/home_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/add_favorite_pokemon.dart';

@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'add_favorite_pokemon_test.mocks.dart';

void main() {
  late MockPokemonRepository mockPokemonRepository;
  late AddFavoritePokemon useCase;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    useCase = AddFavoritePokemon(mockPokemonRepository);
  });

  const tBool = true;

  const tPokemon = Pokemon(
    id: 1,
    name: 'Test',
    height: 1,
    weight: 1,
    stats: [],
    types: [],
    sprites: PokemonSprites(
      other: OtherPokemonSprites(
        home: HomeSprites(frontDefault: ''),
      ),
    ),
  );

  test(
    'should add the pokemon into the favorite list in the repository',
    () async {
      // arrange
      when(mockPokemonRepository.addFavoritePokemon(any))
          .thenAnswer((_) async => const Right(tBool));

      // act
      final result = await useCase(
        const AddFavoritePokemonParams(
          pokemon: tPokemon,
        ),
      );

      // assert
      expect(result, const Right(tBool));
      verify(mockPokemonRepository.addFavoritePokemon(tPokemon));
      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
