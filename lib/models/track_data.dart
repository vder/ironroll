import 'package:hive/hive.dart';

part 'track_data.g.dart';

@HiveType(typeId: 100)
class TrackData {
  @HiveField(0)
  final String label;

  @HiveField(1)
  final int min;

  @HiveField(2)
  final int current;

  @HiveField(3)
  final int max;

  TrackData({
    required this.label,
    required this.min,
    required this.current,
    required this.max,
  });
}
