import 'package:equatable/equatable.dart';

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

  /// A list of base stat values for this Pokemon.
  final List<PokemonStat> stats;

  /// A list of details showing types this Pokemon has.
  final List<PokemonType> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.stats,
    required this.types,
  });

  @override
  List<Object> get props => [id, name, height, weight, stats, types];
}
