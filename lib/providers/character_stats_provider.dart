import 'package:flutter/foundation.dart';
import '../model/user.dart';

class CharacterProvider with ChangeNotifier {
  Character user = Character(
    "John Doe",
    2, // edge
    2, // heart
    1, // iron
    1, // shadow
    3, // wits
  );

  Character get stats => user;

  int getStat(String label) {
    final statName = StatName.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == label,
    );
    return getStatFromEnum(statName);
  }

  void updateName(String name) {
    user.name = name;
    notifyListeners();
  }

  int getStatFromEnum(StatName stat) {
    switch (stat) {
      case StatName.edge:
        return user.edge.value;
      case StatName.heart:
        return user.heart.value;
      case StatName.iron:
        return user.iron.value;
      case StatName.shadow:
        return user.shadow.value;
      case StatName.wits:
        return user.wits.value;
    }
  }

  void updateStat(String label, int value) {
    final statName = StatName.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == label,
    );
    updateStatFromEnum(statName, value);
  }

  void updateStatFromEnum(StatName stat, int value) {
    if (value >= 0 && value <= 5) {
      switch (stat) {
        case StatName.edge:
          user.edge = Stat(name: StatName.edge, value: value);
        case StatName.heart:
          user.heart = Stat(name: StatName.heart, value: value);
        case StatName.iron:
          break;
        case StatName.shadow:
          user.shadow = Stat(name: StatName.shadow, value: value);
        case StatName.wits:
          user.wits = Stat(name: StatName.wits, value: value);
      }
      notifyListeners();
    }
  }

  void incrementStat(String label) {
    final statName = StatName.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == label,
    );
    incrementStatFromEnum(statName);
  }

  void incrementStatFromEnum(StatName stat) {
    final currentValue = getStatFromEnum(stat);
    if (currentValue < 5) {
      updateStatFromEnum(stat, currentValue + 1);
    }
  }

  void decrementStat(String label) {
    final statName = StatName.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == label,
    );
    decrementStatFromEnum(statName);
  }

  void decrementStatFromEnum(StatName stat) {
    final currentValue = getStatFromEnum(stat);
    if (currentValue > 0) {
      updateStatFromEnum(stat, currentValue - 1);
    }
  }
}
