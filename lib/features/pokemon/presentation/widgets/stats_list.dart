import 'package:flutter/material.dart';

import 'package:pokedex_app/core/utils/utils.dart';
import 'package:pokedex_app/features/pokemon/domain/entities/pokemon_stat.dart';

const maxBaseStat = 255;

class StatsList extends StatelessWidget {
  final List<PokemonStat> stats;

  const StatsList({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _StatItem(pokemonStat: stats[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: stats.length,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final PokemonStat pokemonStat;

  const _StatItem({required this.pokemonStat});

  @override
  Widget build(BuildContext context) {
    final statName =
        pokemonStat.stat.name.split('-').map((e) => toTitleCase(e)).join(' ');

    return Row(
      children: [
        Expanded(
          child: Text(
            statName,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 48,
          child: Text(
            '${pokemonStat.baseStat}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: _StatChart(pokemonStat.baseStat)),
      ],
    );
  }
}

class _StatChart extends StatelessWidget {
  const _StatChart(this.baseStat);

  final int baseStat;

  @override
  Widget build(BuildContext context) {
    final stat = baseStat / maxBaseStat;
    final statColor = getStatColor(baseStat);

    return Container(
      width: double.infinity,
      height: 8,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        gradient: LinearGradient(
          // Begin with the stat.
          begin: const Alignment(-1, 0),
          // The end starts from the end of the base stat.
          end: Alignment(-1 + stat, 0),
          colors: [statColor, Colors.grey.shade200],
          stops: const [1, 1],
        ),
      ),
    );
  }

  /// Returns a [Color] which indicates how good is the [baseStat].
  ///
  /// Ranges taken from https://marriland.com/glossary/base-stats/
  Color getStatColor(int baseStat) {
    // Very low.
    if (baseStat < 40) return Colors.red.shade900;

    // Low.
    if (baseStat < 65) return Colors.red.shade600;

    // Average.
    if (baseStat < 80) return Colors.orange.shade300;

    // Decent.
    if (baseStat < 90) return Colors.orange.shade600;

    // Good.
    if (baseStat < 110) return Colors.green.shade300;

    // Great.
    if (baseStat < 130) return Colors.green.shade600;

    // Excellent.
    return Colors.green.shade900;
  }
}
