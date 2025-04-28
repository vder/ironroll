import 'dart:math';

sealed class Roll {}

class ActionRoll extends Roll {
  final int statValue;
  final int modifier;
  final int actionDie;
  final List<int> challengeDice;
  late final int actionScore;

  ActionRoll({this.statValue = 0, this.modifier = 0})
    : actionDie = Random().nextInt(6) + 1,
      challengeDice = [Random().nextInt(10) + 1, Random().nextInt(10) + 1] {
    int total = actionDie + statValue + modifier;
    actionScore = total.clamp(0, 10);
  }

  String getOutcome() {
    int hits = challengeDice.where((die) => actionScore > die).length;
    if (hits == 2) {
      return 'Strong Hit';
    } else if (hits == 1) {
      return 'Weak Hit';
    } else {
      return 'Miss';
    }
  }
}

class OracleRoll extends Roll {
  final int roll;

  OracleRoll() : roll = Random().nextInt(100);
}
