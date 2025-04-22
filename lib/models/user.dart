import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 10)
enum StatName {
  @HiveField(0)
  edge,
  @HiveField(1)
  heart,
  @HiveField(2)
  iron,
  @HiveField(3)
  shadow,
  @HiveField(4)
  wits,
}

@HiveType(typeId: 11)
class Stat {
  @HiveField(0)
  final StatName name;

  @HiveField(1)
  final int value;

  Stat({required this.name, required this.value});
}

@HiveType(typeId: 12)
class Character {
  @HiveField(0)
  String name;

  @HiveField(1)
  Stat edge;

  @HiveField(2)
  Stat heart;

  @HiveField(3)
  Stat iron;

  @HiveField(4)
  Stat shadow;

  @HiveField(5)
  Stat wits;

  Character({
    required this.name,
    required this.edge,
    required this.heart,
    required this.iron,
    required this.shadow,
    required this.wits,
  });

  factory Character.create(
    String name,
    int edgeValue,
    int heartValue,
    int ironValue,
    int shadowValue,
    int witsValue,
  ) {
    return Character(
      name: name,
      edge: Stat(name: StatName.edge, value: edgeValue),
      heart: Stat(name: StatName.heart, value: heartValue),
      iron: Stat(name: StatName.iron, value: ironValue),
      shadow: Stat(name: StatName.shadow, value: shadowValue),
      wits: Stat(name: StatName.wits, value: witsValue),
    );
  }
}
