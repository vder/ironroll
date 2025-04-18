import 'package:flutter/material.dart';

class ProgressTrack extends StatefulWidget {
  final String name;
  final String rank;
  final int ticks; // total ticks (0–40)
  final void Function(int)? onChanged;

  const ProgressTrack({
    Key? key,
    required this.name,
    required this.rank,
    required this.ticks,
    this.onChanged,
  }) : super(key: key);

  @override
  State<ProgressTrack> createState() => _ProgressTrackState();
}

class _ProgressTrackState extends State<ProgressTrack> {
  late int _ticks;

  @override
  void initState() {
    super.initState();
    _ticks = widget.ticks.clamp(0, 40);
  }

  /// Correct ticks gained per "progress mark", based on Starforged rules
  int get ticksPerMark {
    switch (widget.rank.toLowerCase()) {
      case 'troublesome':
        return 12;
      case 'dangerous':
        return 8;
      case 'formidable':
        return 4;
      case 'extreme':
        return 2;
      case 'epic':
        return 1;
      default:
        return 1;
    }
  }

  void _incrementTick() {
    setState(() {
      _ticks = (_ticks + ticksPerMark).clamp(0, 40);
      widget.onChanged?.call(_ticks);
    });
  }

  void _decrementTick() {
    setState(() {
      _ticks = (_ticks - ticksPerMark).clamp(0, 40);
      widget.onChanged?.call(_ticks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Rank
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              Text(
                widget.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(widget.rank, style: const TextStyle(fontSize: 10)),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.grey.shade200,
              ),
            ],
          ),
        ),
        // Progress Row
        GestureDetector(
          onTap: _incrementTick,
          onLongPress: _decrementTick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(10, (boxIndex) {
              int boxTicks = (_ticks - boxIndex * 4).clamp(0, 4);
              return Container(
                margin: const EdgeInsets.all(4),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    boxTicks > 0 ? '$boxTicks' : '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
