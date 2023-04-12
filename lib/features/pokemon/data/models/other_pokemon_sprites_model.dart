import 'package:pokedex_app/features/pokemon/data/models/home_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/other_pokemon_sprites.dart';

class OtherPokemonSpritesModel extends OtherPokemonSprites {
  const OtherPokemonSpritesModel({required super.home});

  factory OtherPokemonSpritesModel.fromJson(Map<String, dynamic> json) {
    return OtherPokemonSpritesModel(
      home: HomeSpritesModel.fromJson(json['home']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home': home.toJson(),
    };
  }

  @override
  HomeSpritesModel get home {
    return HomeSpritesModel(
      frontDefault: super.home.frontDefault,
    );
  }
}
