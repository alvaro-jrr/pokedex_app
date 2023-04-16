import 'package:flutter/material.dart';

import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_type.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/type.dart';

class TypesList extends StatelessWidget {
  final List<PokemonType> types;

  const TypesList({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _TypeItem(types[index].type),
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: types.length,
      ),
    );
  }
}

class _TypeItem extends StatelessWidget {
  final Type type;

  const _TypeItem(this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: Colors.blue.shade50,
        shape: const StadiumBorder(),
      ),
      child: Text(
        toTitleCase(type.name),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.blue,
        ),
      ),
    );
  }
}