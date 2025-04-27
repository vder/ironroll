import 'package:flutter/material.dart';
import 'package:ironroll/widgets/vertical_track.dart';

class ConditionMeters extends StatelessWidget {
  const ConditionMeters({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          VerticalTrack(label: 'Momentum', min: -6, current: 2, max: 10),
          VerticalTrack(label: 'Health', min: 0, current: 4, max: 5),
          VerticalTrack(label: 'Spirit', min: 0, current: 3, max: 5),
          VerticalTrack(label: 'Supply', min: 0, current: 3, max: 5),
        ],
      ),
    );
  }
}
