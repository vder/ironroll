import 'package:flutter/material.dart';
import 'package:ironroll/services/character_service.dart';
import 'package:ironroll/models/user.dart';
import 'package:ironroll/widgets/roll_result_card.dart';
import 'dart:math';

class RollsPage extends StatefulWidget {
  final CharacterService characterService;

  const RollsPage({super.key, required this.characterService});

  @override
  State<RollsPage> createState() => _RollsPageState();
}

class _RollsPageState extends State<RollsPage> {
  bool isActionRoll = true;
  bool isOracleRoll = false;
  final Map<StatName, bool> _selectedStats = {
    StatName.edge: false,
    StatName.heart: false,
    StatName.iron: false,
    StatName.shadow: false,
    StatName.wits: false,
  };
  int actionDie = 0;
  List<int> d10s = [];
  int d100 = 0;

  void actionRoll() {
    int increase = 0;
    _selectedStats.forEach((stat, isSelected) {
      if (isSelected) {
        increase += widget.characterService.getStatFromEnum(stat);
      }
    });

    setState(() {
      actionDie = Random().nextInt(6) + 1 + increase;
      d10s = List.generate(2, (index) => Random().nextInt(10) + 1);
      isActionRoll = true;
      isOracleRoll = false;
    });
  }

  void oracleRoll() {
    setState(() {
      d100 = Random().nextInt(100) + 1;
      isOracleRoll = true;
      isActionRoll = false;
    });
  }

  void _toggleStat(StatName stat) {
    setState(() {
      // First, set all stats to false
      for (var key in _selectedStats.keys) {
        if (key != stat) {
          _selectedStats[key] = false;
        } else {
          // Then, set the selected stat to true
          _selectedStats[key] = !_selectedStats[key]!;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Character: ${widget.characterService.stats.name}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: actionRoll,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text('Action Roll'),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: oracleRoll,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text('Oracle Roll'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isActionRoll) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var entry in _selectedStats.entries)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ChoiceChip(
                        label: Text(
                          entry.key.toString().split('.').last.toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        selected: entry.value,
                        onSelected: (selected) => _toggleStat(entry.key),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (actionDie > 0) ...[RollResultCard(d6: actionDie, d10s: d10s)],
          ],
          if (isOracleRoll) ...[RollResultCard.d100(d100: d100)],
        ],
      ),
    );
  }
}
