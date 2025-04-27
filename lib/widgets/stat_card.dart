import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironroll/models/user.dart';
import 'package:ironroll/services/character_service.dart';
import 'package:ironroll/widgets/stat_box.dart';

class StatCard extends StatelessWidget {
  final CharacterService characterService;
  final VoidCallback onChanged;

  const StatCard({
    super.key,
    required this.characterService,
    required this.onChanged,
  });

  void _incrementStat(String stat) async {
    await characterService.incrementStat(stat);
    onChanged();
  }

  void _decrementStat(String stat) async {
    await characterService.decrementStat(stat);
    onChanged();
  }

  Widget sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  List<Widget> _statBoxesList() {
    return StatName.values.map((stat) {
      return StatBox(
        label: stat.name.toUpperCase(),
        value: characterService.getStat(stat.name),
        onIncrement: () => _incrementStat(stat.name),
        onDecrement: () => _decrementStat(stat.name),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [sectionTitle(context, "Stats"), ..._statBoxesList()],
        ),
      ),
    );
  }
}
