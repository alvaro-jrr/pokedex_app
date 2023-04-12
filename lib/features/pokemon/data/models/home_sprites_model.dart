import 'package:pokedex_app/features/pokemon/domain/entities/home_sprites.dart';

class HomeSpritesModel extends HomeSprites {
  const HomeSpritesModel({required super.frontDefault});

  factory HomeSpritesModel.fromJson(Map<String, dynamic> json) {
    return HomeSpritesModel(frontDefault: json['front_default']);
  }

  Map<String, dynamic> toJson() {
    return {
      'front_default': frontDefault,
    };
  }
}
