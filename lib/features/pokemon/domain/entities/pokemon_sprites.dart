import 'package:equatable/equatable.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';

class PokemonSprites extends Equatable {
  final OtherPokemonSprites other;

  const PokemonSprites({
    required this.other,
  });

  @override
  List<Object> get props => [other];
}
