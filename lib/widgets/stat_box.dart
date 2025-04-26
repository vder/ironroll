import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatBox extends StatelessWidget {
  const StatBox({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

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
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Container(
            width: 65,
            height: 65,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$value',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: value < 5 ? onIncrement : null,
                child: Icon(
                  Icons.arrow_drop_up,
                  size: 36,
                  color:
                      value < 5
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                ),
              ),
              InkWell(
                onTap: value > 0 ? onDecrement : null,
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 36,
                  color:
                      value > 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
