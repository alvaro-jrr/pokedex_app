import 'package:pokedex_app/features/pokemon/data/models/other_pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';

class PokemonSpritesModel extends PokemonSprites {
  const PokemonSpritesModel({required super.other});

  factory PokemonSpritesModel.fromJson(Map<String, dynamic> json) {
    return PokemonSpritesModel(
      other: OtherPokemonSpritesModel.fromJson(json['other']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'other': other.toJson(),
    };
  }

  @override
  OtherPokemonSpritesModel get other {
    return OtherPokemonSpritesModel(home: super.other.home);
  }
}
