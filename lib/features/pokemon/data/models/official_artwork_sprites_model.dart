import 'package:pokedex_app/features/pokemon/domain/entities/official_artwork_sprites.dart';

class OfficialArtworkSpritesModel extends OfficialArtworkSprites {
  const OfficialArtworkSpritesModel({required super.frontDefault});

  factory OfficialArtworkSpritesModel.fromJson(Map<String, dynamic> json) {
    return OfficialArtworkSpritesModel(frontDefault: json['front_default']);
  }

  Map<String, dynamic> toJson() {
    return {
      'front_default': frontDefault,
    };
  }
}
