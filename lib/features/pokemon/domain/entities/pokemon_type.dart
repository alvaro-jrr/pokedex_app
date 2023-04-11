import 'package:equatable/equatable.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

class PokemonType extends Equatable {
  /// The order the Pokemon's types are listed in.
  final int slot;

  /// The type the referenced Form has.
  final List<Type> types;

  const PokemonType({
    required this.slot,
    required this.types,
  });

  @override
  List<Object> get props => [slot, types];
}
