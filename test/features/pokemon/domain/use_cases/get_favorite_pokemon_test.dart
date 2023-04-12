import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/home_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_favorite_pokemon.dart';

@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'get_favorite_pokemon_test.mocks.dart';

void main() {
  late MockPokemonRepository mockPokemonRepository;
  late GetFavoritePokemon useCase;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    useCase = GetFavoritePokemon(mockPokemonRepository);
  });

  const tId = 1;

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
    'should get the favorite pokemon with the id from the repository',
    () async {
      // arrange
      when(mockPokemonRepository.getFavoritePokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));

      // act
      final result = await useCase(const GetFavoritePokemonParams(id: tId));

      // assert
      expect(result, const Right(tPokemon));
      verify(mockPokemonRepository.getFavoritePokemon(tId));
      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
