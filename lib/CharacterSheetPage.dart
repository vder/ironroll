import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ironroll/providers/character_stats_provider.dart';

class CharacterSheetPage extends StatefulWidget {
  const CharacterSheetPage({super.key});

  @override
  State<CharacterSheetPage> createState() => _CharacterSheetPageState();
}

class _CharacterSheetPageState extends State<CharacterSheetPage> {
  final Map<String, bool> impacts = {
    "Wounded": false,
    "Shaken": false,
    "Unprepared": false,
    "Permanently Harmed": false,
    "Traumatized": false,
    "Doomed": false,
    "Tormented": false,
    "Indebted": false,
    "Battered": false,
    "Cursed": false,
  };

  // Add state management for stats
  final Map<String, int> stats = {
    'EDGE': 2,
    'HEART': 2,
    'IRON': 1,
    'SHADOW': 1,
    'WITS': 3,
  };

  Widget statBox(String label, int value) {
    // Get the provider
    final statsProvider = Provider.of<CharacterStatsProvider>(context);

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
                      '${statsProvider.getStat(label)}',
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
                    onTap: () => statsProvider.incrementStat(label),
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 36,
                      color:
                          statsProvider.getStat(label) < 5
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300],
                    ),
                  ),
                  InkWell(
                    onTap: () => statsProvider.decrementStat(label),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 36,
                      color:
                          statsProvider.getStat(label) > 0
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

  Widget verticalTrack(String label, int min, int current, int max) {
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

  Widget checkboxLabel(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            impacts[text]!
                ? Theme.of(context).colorScheme.error.withOpacity(0.1)
                : Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: impacts[text],
            onChanged: (value) {
              setState(() {
                impacts[text] = value!;
              });
            },
          ),
          Text(
            text,
            style: GoogleFonts.robotoCondensed(
              fontSize: 14,
              color:
                  impacts[text]!
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.robotoCondensed(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHARACTER SHEET',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: _buildInputDecoration('Name'),
                              style: GoogleFonts.robotoCondensed(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: _buildInputDecoration('Pronouns'),
                              style: GoogleFonts.robotoCondensed(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: _buildInputDecoration('Characteristics'),
                        style: GoogleFonts.robotoCondensed(),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Stats
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              sectionTitle("Stats"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  statBox('EDGE', 0),
                                  statBox('HEART', 0),
                                  statBox('IRON', 0),
                                  statBox('SHADOW', 0),
                                  statBox('WITS', 0),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Impacts
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionTitle("Impacts"),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    impacts.keys
                                        .map((impact) => checkboxLabel(impact))
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Assets
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionTitle("Assets"),
                              TextFormField(
                                decoration: _buildInputDecoration(
                                  'List assets, items, starships, etc.',
                                ),
                                style: GoogleFonts.robotoCondensed(),
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Footer Controls
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              verticalTrack('Momentum', -6, 2, 10),
                              Column(
                                children: [
                                  verticalTrack('Health', 0, 4, 5),
                                  verticalTrack('Spirit', 0, 3, 5),
                                  verticalTrack('Supply', 0, 3, 5),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
