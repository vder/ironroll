import 'package:hive/hive.dart';

part 'quest.g.dart';

@HiveType(typeId: 200)
enum QuestRank {
  @HiveField(0)
  troublesome,
  @HiveField(1)
  dangerous,
  @HiveField(2)
  formidable,
  @HiveField(3)
  extreme,
  @HiveField(4)
  epic,
}

@HiveType(typeId: 201)
class Quest {
  @HiveField(0)
  final String name;

  @HiveField(1)
  QuestRank rank;

  @HiveField(2)
  int progress;

  Quest({required this.name, required this.rank, this.progress = 0});
}
