import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalTrack extends StatelessWidget {
  const VerticalTrack({
    super.key,
    required this.context,
    required this.label,
    required this.min,
    required this.current,
    required this.max,
  });

  final BuildContext context;
  final String label;
  final int min;
  final int current;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            max - min + 1,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    size: 14,
                    color:
                        (max - index) == current
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                  ),
                  Text(
                    '${max - index}',
                    style: GoogleFonts.cinzel(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
