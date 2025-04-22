import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class CharacterProvider with ChangeNotifier {
  late Box<Character> _characterBox;
  late Character user;

  CharacterProvider() {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    _characterBox = await Hive.openBox<Character>('character');
    if (_characterBox.isEmpty) {
      user = Character.create(
        "John Doe",
        2, // edge
        2, // heart
        1, // iron
        1, // shadow
        3, // wits
      );
      await _characterBox.put('current', user);
    } else {
      user = _characterBox.get('current')!;
    }
    notifyListeners();
  }

  Character get stats => user;

  int getStat(String label) {
    final statName = StatName.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == label,
    );
    return getStatFromEnum(statName);
  }

  Future<void> updateName(String name) async {
    user.name = name;
    await _characterBox.put('current', user);
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

  Future<void> updateStat(String label, int value) async {
    final statName = StatName.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == label,
    );
    await updateStatFromEnum(statName, value);
  }

  Future<void> updateStatFromEnum(StatName stat, int value) async {
    if (value >= 0 && value <= 5) {
      switch (stat) {
        case StatName.edge:
          user.edge = Stat(name: StatName.edge, value: value);
        case StatName.heart:
          user.heart = Stat(name: StatName.heart, value: value);
        case StatName.iron:
          user.iron = Stat(name: StatName.iron, value: value);
        case StatName.shadow:
          user.shadow = Stat(name: StatName.shadow, value: value);
        case StatName.wits:
          user.wits = Stat(name: StatName.wits, value: value);
      }
      await _characterBox.put('current', user);
      notifyListeners();
    }
  }

  Future<void> incrementStat(String label) async {
    final statName = StatName.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == label,
    );
    await incrementStatFromEnum(statName);
  }

  Future<void> incrementStatFromEnum(StatName stat) async {
    final currentValue = getStatFromEnum(stat);
    if (currentValue < 5) {
      await updateStatFromEnum(stat, currentValue + 1);
    }
  }

  Future<void> decrementStat(String label) async {
    final statName = StatName.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == label,
    );
    await decrementStatFromEnum(statName);
  }

  Future<void> decrementStatFromEnum(StatName stat) async {
    final currentValue = getStatFromEnum(stat);
    if (currentValue > 0) {
      await updateStatFromEnum(stat, currentValue - 1);
    }
  }
}
