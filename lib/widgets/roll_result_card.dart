import 'package:flutter/material.dart';

class RollResultCard extends StatelessWidget {
  const RollResultCard.d100({super.key, required this.d100})
    : d6 = null,
      d10s = null,
      isD100 = true;

  const RollResultCard({super.key, required this.d6, required this.d10s})
    : d100 = null,
      isD100 = false;

  final int? d6;
  final List<int>? d10s;
  final int? d100;
  final bool isD100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (!isD100) ...[
              // Display for d6 and d10s roll
              Text("$d6, $d10s", style: textStyle.copyWith(fontSize: 24)),
              if (d10s!.every((x) => d6! > x))
                Text("Strong Hit", style: textStyle.copyWith(fontSize: 20))
              else if (d10s!.any((x) => d6! > x))
                Text("Weak Hit", style: textStyle.copyWith(fontSize: 20))
              else
                Text("Miss", style: textStyle.copyWith(fontSize: 20)),
              if (d10s!.first == d10s!.last)
                Text("Matched", style: textStyle.copyWith(fontSize: 20)),
            ] else ...[
              // Display for d100 roll
              Text("$d100", style: textStyle.copyWith(fontSize: 24)),
              // Add any specific d100 roll logic here
            ],
          ],
        ),
      ),
    );
  }
}
