import 'package:flutter/material.dart';
import 'package:ironroll/models/roll.dart';
import 'package:ironroll/services/character_service.dart';
import 'package:ironroll/models/user.dart';
import 'package:ironroll/widgets/roll_result_card.dart';

class RollsPage extends StatefulWidget {
  final CharacterService characterService;

  const RollsPage({super.key, required this.characterService});

  @override
  State<RollsPage> createState() => _RollsPageState();
}

class _RollsPageState extends State<RollsPage> {
  Roll? roll;
  int modifier = 0;
  StatName? statName;

  void doActionRoll() {
    setState(() {
      roll = ActionRoll(
        statValue:
            (statName != null)
                ? widget.characterService.getStatFromEnum(statName!)
                : 0,
        modifier: modifier,
      );
    });
  }

  void doOracleRoll() {
    setState(() {
      roll = OracleRoll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Character: ${widget.characterService.stats.name}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: doActionRoll,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Action Roll'),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: doOracleRoll,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Oracle Roll'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Stat"),
                DropdownButton(
                  value: statName,
                  items: [
                    const DropdownMenuItem<StatName?>(
                      value: null,
                      child: Text('NONE'), // or '-', or whatever you want
                    ),
                    ...StatName.values.map(
                      (statName) => DropdownMenuItem(
                        value: statName,
                        child: Text(
                          "${statName.name.toUpperCase()} (${widget.characterService.getStatFromEnum(statName)})",
                        ),
                      ),
                    ),
                  ],
                  onChanged: (mod) => setState(() => statName = mod),
                ),
              ],
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Modifier"),
                DropdownButton(
                  value: modifier,
                  items:
                      List.generate(11, (index) => index - 5)
                          .map(
                            (i) =>
                                DropdownMenuItem(value: i, child: Text("$i")),
                          )
                          .toList(),
                  onChanged: (mod) {
                    if (mod != null) {
                      setState(() => modifier = mod);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        (roll != null) ? RollResultCard(roll: roll!) : Card(),
      ],
    );
  }
}
