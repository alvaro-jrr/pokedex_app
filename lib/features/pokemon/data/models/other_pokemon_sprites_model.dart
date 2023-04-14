import 'package:pokedex_app/features/pokemon/data/models/official_artwork_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';

class OtherPokemonSpritesModel extends OtherPokemonSprites {
  const OtherPokemonSpritesModel({required super.officialArtwork});

  factory OtherPokemonSpritesModel.fromJson(Map<String, dynamic> json) {
    return OtherPokemonSpritesModel(
      officialArtwork:
          OfficialArtworkSpritesModel.fromJson(json['official-artwork']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'official-artwork': officialArtwork.toJson(),
    };
  }

  @override
  OfficialArtworkSpritesModel get officialArtwork {
    return OfficialArtworkSpritesModel(
      frontDefault: super.officialArtwork.frontDefault,
    );
  }
}
