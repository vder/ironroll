enum StatName { edge, heart, iron, shadow, wits }

class Stat {
  final StatName name;
  final int value;

  Stat({required this.name, required this.value});
}

class Character {
  String name;
  late Stat edge;
  late Stat heart;
  late Stat iron;
  late Stat shadow;
  late Stat wits;

  Character(
    this.name,
    int edgeValue,
    int heartValue,
    int ironValue,
    int shadowValue,
    int witsValue,
  ) {
    edge = Stat(name: StatName.edge, value: edgeValue);
    heart = Stat(name: StatName.heart, value: heartValue);
    iron = Stat(name: StatName.iron, value: ironValue);
    shadow = Stat(name: StatName.shadow, value: shadowValue);
    wits = Stat(name: StatName.wits, value: witsValue);
  }
}
