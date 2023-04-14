import 'package:equatable/equatable.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_type.dart';

class Pokemon extends Equatable {
  /// The identifier for this resource.
  final int id;

  /// The name for this resource.
  final String name;

  /// The height of this Pokemon in decimetres.
  final int height;

  /// The weight of this Pokemon in hectograms.
  final int weight;

  /// A set of sprites used to depict this Pokemon.
  final PokemonSprites sprites;

  /// A list of base stat values for this Pokemon.
  final List<PokemonStat> stats;

  /// A list of details showing types this Pokemon has.
  final List<PokemonType> types;

  /// The favorite state of this Pokemon.
  final bool isFavorite;

  const Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.sprites,
    required this.stats,
    required this.types,
    this.isFavorite = false,
  });

  @override
  List<Object> get props {
    return [id, name, height, weight, sprites, stats, types, isFavorite];
  }
}
