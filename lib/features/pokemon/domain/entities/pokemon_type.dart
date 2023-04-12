import 'package:equatable/equatable.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

class PokemonType extends Equatable {
  /// The order the Pokemon's types are listed in.
  final int slot;

  /// The type the referenced Form has.
  final Type type;

  const PokemonType({
    required this.slot,
    required this.type,
  });

  @override
  List<Object> get props => [slot, type];
}
