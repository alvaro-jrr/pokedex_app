import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:pokedex_app/features/pokemon/domain/entities/pokemon.dart';

class PokemonImage extends StatelessWidget {
  final Pokemon pokemon;
  final double? height;
  final double? width;

  const PokemonImage(
    this.pokemon, {
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      imageSemanticLabel: 'Ilustración de ${pokemon.name}',
      placeholder: const AssetImage('images/loading.gif'),
      image: CachedNetworkImageProvider(
        pokemon.sprites.other.officialArtwork.frontDefault,
        cacheKey: '${pokemon.id}',
      ),
      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
        'images/no-image.png',
        height: height,
        width: width,
        fit: BoxFit.contain,
      ),
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }
}
