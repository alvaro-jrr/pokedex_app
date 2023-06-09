import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon/domain/use_cases/remove_favorite_pokemon.dart';

@GenerateNiceMocks([MockSpec<PokemonRepository>()])
import 'remove_favorite_pokemon_test.mocks.dart';

void main() {
  late MockPokemonRepository mockPokemonRepository;
  late RemoveFavoritePokemon useCase;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    useCase = RemoveFavoritePokemon(mockPokemonRepository);
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

  const tId = 1;

  test(
    'should remove the pokemon of the list with the id from the repository',
    () async {
      // arrange
      when(mockPokemonRepository.removeFavoritePokemon(any))
          .thenAnswer((_) async => const Right(tPokemon));

      // act
      final result = await useCase(const RemoveFavoritePokemonParams(id: tId));

      // assert
      expect(result, const Right(tPokemon));
      verify(mockPokemonRepository.removeFavoritePokemon(tId));
      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
