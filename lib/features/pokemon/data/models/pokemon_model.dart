import 'package:pokedex_app/features/pokemon/data/models/pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_stat_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/pokemon_type_model.dart';
import 'package:pokedex_app/features/pokemon/data/models/stat_model.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_type.dart';

class PokemonModel extends Pokemon {
  const PokemonModel({
    required super.id,
    required super.name,
    required super.height,
    required super.weight,
    required super.sprites,
    required super.stats,
    required super.types,
    super.isFavorite,
  });

  @override
  PokemonSpritesModel get sprites {
    return PokemonSpritesModel(other: super.sprites.other);
  }

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonStats = json['stats'];
    final List<dynamic> jsonTypes = json['types'];

    return PokemonModel(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      sprites: PokemonSpritesModel.fromJson(json['sprites']),
      stats: jsonStats.map((jsonStat) {
        return PokemonStatModel(
          baseStat: jsonStat['base_stat'],
          stat: StatModel.fromJson(jsonStat['stat']),
        );
      }).toList(),
      types: jsonTypes.map((jsonType) {
        return PokemonTypeModel.fromJson(jsonType);
      }).toList(),
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  PokemonModel copyWith({
    int? id,
    String? name,
    int? height,
    int? weight,
    PokemonSprites? sprites,
    List<PokemonStat>? stats,
    List<PokemonType>? types,
    bool? isFavorite,
  }) {
    return PokemonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      sprites: sprites ?? this.sprites,
      stats: stats ?? this.stats,
      types: types ?? this.types,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'weight': weight,
      'sprites': sprites.toJson(),
      'stats': stats.map((stat) => stat.toJson()).toList(),
      'types': types.map((type) => type.toJson()).toList(),
      'is_favorite': isFavorite,
    };
  }

  @override
  List<PokemonStatModel> get stats {
    return super.stats.map((stat) {
      return PokemonStatModel(
        baseStat: stat.baseStat,
        stat: stat.stat,
      );
    }).toList();
  }

  @override
  List<PokemonTypeModel> get types {
    return super.types.map((type) {
      return PokemonTypeModel(
        slot: type.slot,
        type: type.type,
      );
    }).toList();
  }
}
