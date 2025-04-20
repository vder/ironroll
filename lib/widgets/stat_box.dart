import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironroll/providers/character_stats_provider.dart';
import 'package:provider/provider.dart';

class StatBox extends StatelessWidget {
  const StatBox({
    super.key,
    required this.context,
    required this.label,
    required this.value,
  });

  final BuildContext context;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    // Get the provider
    final characterProvider = Provider.of<CharacterProvider>(context);

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                width: 65,
                height: 65,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${characterProvider.getStat(label)}',
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
                    onTap: () => characterProvider.incrementStat(label),
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 36,
                      color:
                          characterProvider.getStat(label) < 5
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300],
                    ),
                  ),
                  InkWell(
                    onTap: () => characterProvider.decrementStat(label),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 36,
                      color:
                          characterProvider.getStat(label) > 0
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
