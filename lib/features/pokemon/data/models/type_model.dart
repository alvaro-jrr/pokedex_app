import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

class TypeModel extends Type {
  const TypeModel({required super.name});

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
