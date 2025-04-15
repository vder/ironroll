import 'package:flutter/foundation.dart';

class CharacterStatsProvider with ChangeNotifier {
  final Map<String, int> _stats = {
    'EDGE': 2,
    'HEART': 2,
    'IRON': 1,
    'SHADOW': 1,
    'WITS': 3,
  };

  Map<String, int> get stats => _stats;

  int getStat(String stat) => _stats[stat] ?? 0;

  void updateStat(String stat, int value) {
    if (value >= 0 && value <= 5) {
      // Enforce limits
      _stats[stat] = value;
      notifyListeners();
    }
  }

  void incrementStat(String stat) {
    if (_stats[stat]! < 5) {
      _stats[stat] = _stats[stat]! + 1;
      notifyListeners();
    }
  }

  void decrementStat(String stat) {
    if (_stats[stat]! > 0) {
      _stats[stat] = _stats[stat]! - 1;
      notifyListeners();
    }
  }
}
