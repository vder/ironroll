import 'package:flutter/material.dart';
import 'package:ironroll/main.dart';
import 'package:ironroll/big_card.dart';
import 'package:provider/provider.dart';
import 'package:ironroll/providers/character_stats_provider.dart';
import 'dart:math';

class RollsPage extends StatefulWidget {
  @override
  State<RollsPage> createState() => _RollsPageState();
}

class _RollsPageState extends State<RollsPage> {
  final Map<String, bool> _selectedStats = {
    'EDGE': false,
    'HEART': false,
    'IRON': false,
    'SHADOW': false,
    'WITS': false,
  };

  bool isActionRoll = false;
  bool isOracleRoll = false;
  int d6 = 0;
  List<int> d10s = [];
  int d100 = 0;

  void actionRoll(CharacterStatsProvider statsProvider) {
    int increase = 0;
    _selectedStats.forEach((key, value) {
      if (value) {
        increase = increase + statsProvider.getStat(key);
      }
    });
    setState(() {
      d6 = Random().nextInt(6) + 1 + increase;
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

  void _toggleStat(String stat) {
    setState(() {
      // First, set all stats to false
      for (var key in _selectedStats.keys) {
        if (key != stat) {
          _selectedStats[key] = false;
        } else
        // Then, set the selected stat to true
        {
          _selectedStats[stat] = !_selectedStats[stat]!;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<CharacterStatsProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(visible: isActionRoll, child: BigCard(d6: d6, d10s: d10s)),
          Visibility(visible: isOracleRoll, child: BigCard.d100(d100: d100)),
          SizedBox(height: 10),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => actionRoll(statsProvider),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Text(
                        "Action Roll",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => oracleRoll(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Text(
                        "Oracle Roll",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var entry in _selectedStats.entries)
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: ChoiceChip(
                          label: Text(
                            entry.key,
                            style: TextStyle(fontSize: 12),
                          ),
                          selected: entry.value,
                          onSelected: (selected) => _toggleStat(entry.key),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
