import 'package:equatable/equatable.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/home.dart';

class OtherPokemonSprites extends Equatable {
  final Home home;

  const OtherPokemonSprites({
    required this.home,
  });

  @override
  List<Object> get props => [home];
}
