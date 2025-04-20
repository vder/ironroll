import 'package:flutter/material.dart';
import 'package:ironroll/model/quest.dart';

class ProgressTrack extends StatefulWidget {
  final Quest quest;
  final void Function(Quest)? onChanged;

  const ProgressTrack({Key? key, required this.quest, this.onChanged})
    : super(key: key);

  @override
  State<ProgressTrack> createState() => _ProgressTrackState();
}

class _ProgressTrackState extends State<ProgressTrack> {
  late Quest _quest;

  @override
  void initState() {
    super.initState();
    _quest = Quest(widget.quest.name, widget.quest.rank)
      ..progress = widget.quest.progress.clamp(0, 40);
  }

  int get ticksPerMark {
    switch (_quest.rank) {
      case QuestRank.troublesome:
        return 12;
      case QuestRank.dangerous:
        return 8;
      case QuestRank.formidable:
        return 4;
      case QuestRank.extreme:
        return 2;
      case QuestRank.epic:
        return 1;
    }
  }

  void _incrementProgress() {
    setState(() {
      _quest.progress = (_quest.progress + ticksPerMark).clamp(0, 40);
      widget.onChanged?.call(_quest);
    });
  }

  void _decrementProgress() {
    setState(() {
      _quest.progress = (_quest.progress - ticksPerMark).clamp(0, 40);
      widget.onChanged?.call(_quest);
    });
  }

  void _updateRank(QuestRank newRank) {
    setState(() {
      _quest.rank = newRank;
      widget.onChanged?.call(_quest);
    });
  }

  String getRankLabel(QuestRank rank) {
    return rank.name[0].toUpperCase() + rank.name.substring(1);
  }

  IconData _iconForTicks(int ticks) {
    switch (ticks) {
      case 1:
        return Icons.looks_one;
      case 2:
        return Icons.looks_two;
      case 3:
        return Icons.looks_3;
      case 4:
        return Icons.check_box;
      default:
        return Icons.crop_square;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quest name
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                _quest.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Rank dropdown
            DropdownButton<QuestRank>(
              value: _quest.rank,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              onChanged: (rank) {
                if (rank != null) _updateRank(rank);
              },
              items:
                  QuestRank.values.map((rank) {
                    return DropdownMenuItem(
                      value: rank,
                      child: Text(getRankLabel(rank)),
                    );
                  }).toList(),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Progress boxes
        GestureDetector(
          onTap: _incrementProgress,
          onLongPress: _decrementProgress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(10, (boxIndex) {
              int boxTicks = (_quest.progress - boxIndex * 4).clamp(0, 4);
              return Container(
                margin: const EdgeInsets.all(4),
                width: 32,
                height: 32,
                child: Icon(_iconForTicks(boxTicks), size: 24),
              );
            }),
          ),
        ),
      ],
    );
  }
}
