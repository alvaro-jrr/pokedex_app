import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/get_concrete_pokemon.dart';

@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'get_concrete_pokemon_test.mocks.dart';

void main() {
  late MockPokemonRepository mockPokemonRepository;
  late GetConcretePokemon useCase;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    useCase = GetConcretePokemon(mockPokemonRepository);
  });

  const tQuery = 'Test';

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
  );

  test(
    'should get the pokemon for the query from the repository',
    () async {
      // arrange
      when(mockPokemonRepository.getConcretePokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));

      // act
      final result = await useCase(
        const GetConcretePokemonParams(query: tQuery),
      );

      // assert
      expect(result, const Right(tPokemon));
      verify(mockPokemonRepository.getConcretePokemon(tQuery));
      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
