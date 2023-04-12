import 'package:pokedex_app/features/pokemon/domain/entities/stat.dart';

class StatModel extends Stat {
  const StatModel({required super.name});

  factory StatModel.fromJson(Map<String, dynamic> json) {
    return StatModel(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
