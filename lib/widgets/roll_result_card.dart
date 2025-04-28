import 'package:flutter/material.dart';
import 'package:ironroll/models/roll.dart';
import 'package:ironroll/widgets/challenge_dice.dart';
import 'package:ironroll/widgets/action_dice.dart';

class RollResultCard extends StatelessWidget {
  const RollResultCard({super.key, required this.roll});

  final Roll roll;

  List<Widget> getRollResults() {
    if (roll is ActionRoll) {
      final actionRoll = roll as ActionRoll;
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionDice(number: actionRoll.actionDie),
            Text(
              " + ${actionRoll.statValue} + ${actionRoll.modifier} = ${actionRoll.actionScore}",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              actionRoll.challengeDice
                  .map(
                    (number) => ChallengeDice(
                      number: number,
                      isHit: actionRoll.actionScore > number,
                    ),
                  )
                  .toList(),
        ),
        Text(
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          actionRoll.getOutcome(),
        ),
      ];
    } else if (roll is OracleRoll) {
      final oracleRoll = roll as OracleRoll;
      return [Text("Oracle Roll: ${oracleRoll.roll}")];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: getRollResults()),
      ),
    );
  }
}
