import 'package:pokedex_app/features/pokemon/data/models/stat_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';

class PokemonStatModel extends PokemonStat {
  const PokemonStatModel({required super.baseStat, required super.stat});

  factory PokemonStatModel.fromJson(Map<String, dynamic> json) {
    return PokemonStatModel(
      baseStat: json['base_stat'],
      stat: StatModel.fromJson(json['stat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_stat': baseStat,
      'stat': stat.toJson(),
    };
  }

  @override
  StatModel get stat {
    return StatModel(name: super.stat.name);
  }
}
