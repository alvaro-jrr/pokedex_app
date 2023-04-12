import 'package:equatable/equatable.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/home_sprites.dart';

class OtherPokemonSprites extends Equatable {
  final HomeSprites home;

  const OtherPokemonSprites({
    required this.home,
  });

  @override
  List<Object> get props => [home];
}
