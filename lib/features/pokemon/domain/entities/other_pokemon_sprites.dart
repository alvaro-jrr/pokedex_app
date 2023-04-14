import 'package:equatable/equatable.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';

class OtherPokemonSprites extends Equatable {
  final OfficialArtworkSprites officialArtwork;

  const OtherPokemonSprites({
    required this.officialArtwork,
  });

  @override
  List<Object> get props => [officialArtwork];
}
