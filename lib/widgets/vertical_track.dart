import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/track_data.dart';

class VerticalTrack extends StatefulWidget {
  const VerticalTrack({
    super.key,
    required this.label,
    required this.min,
    required this.current,
    required this.max,
    this.onValueChanged,
  });

  final String label;
  final int min;
  final int current;
  final int max;
  final void Function(int newValue)? onValueChanged;

  @override
  State<VerticalTrack> createState() => _VerticalTrackState();
}

class _VerticalTrackState extends State<VerticalTrack> {
  late Box<TrackData> _trackBox;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.current;
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    _trackBox = await Hive.openBox<TrackData>('tracks');
    final savedTrack = _trackBox.get(widget.label);
    if (savedTrack != null) {
      setState(() {
        _current = savedTrack.current;
      });
    }
  }

  Future<void> _saveTrackData(int newValue) async {
    final trackData = TrackData(
      label: widget.label,
      min: widget.min,
      current: newValue,
      max: widget.max,
    );
    await _trackBox.put(widget.label, trackData);
  }

  @override
  Widget build(BuildContext context) {
    final blocks = List.generate(widget.max - widget.min + 1, (index) {
      final value = widget.max - index;
      final isActive = value == _current;

      return GestureDetector(
        onTap: () async {
          setState(() {
            _current = value;
          });
          await _saveTrackData(value);
          widget.onValueChanged?.call(value);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: 50,
          decoration: BoxDecoration(
            color:
                isActive
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[300]!,
              width: isActive ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: GoogleFonts.bebasNeue(
              fontSize: 20,
              color:
                  isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[600],
            ),
          ),
        ),
      );
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: GoogleFonts.bebasNeue(
              fontSize: 16,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(children: blocks),
        ),
      ],
    );
  }
}
