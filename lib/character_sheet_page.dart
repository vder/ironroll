import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironroll/widgets/vertical_track.dart';
import 'package:ironroll/widgets/stat_box.dart';
import 'package:provider/provider.dart';
import 'package:ironroll/providers/character_stats_provider.dart';
import 'package:ironroll/widgets/progress_track/progress_track_list.dart';

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
    final characterProvider = Provider.of<CharacterProvider>(context);

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
                child: ListView(
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('Name'),
                            initialValue: characterProvider.user.name,
                            onChanged:
                                (value) => characterProvider.updateName(value),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StatBox(
                                  context: context,
                                  label: 'EDGE',
                                  value: 0,
                                ),
                                StatBox(
                                  context: context,
                                  label: 'HEART',
                                  value: 0,
                                ),
                                StatBox(
                                  context: context,
                                  label: 'IRON',
                                  value: 0,
                                ),
                                StatBox(
                                  context: context,
                                  label: 'SHADOW',
                                  value: 0,
                                ),
                                StatBox(
                                  context: context,
                                  label: 'WITS',
                                  value: 0,
                                ),
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sectionTitle("Quests"),
                            SizedBox(
                              height: 400, // dopasuj jak chcesz
                              child: ProgressTrackList(),
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
                            VerticalTrack(
                              label: 'Momentum',
                              min: -6,
                              current: 2,
                              max: 10,
                            ),
                            Column(
                              children: [
                                VerticalTrack(
                                  label: 'Health',
                                  min: 0,
                                  current: 4,
                                  max: 5,
                                ),
                                VerticalTrack(
                                  label: 'Spirit',
                                  min: 0,
                                  current: 3,
                                  max: 5,
                                ),
                                VerticalTrack(
                                  label: 'Supply',
                                  min: 0,
                                  current: 3,
                                  max: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
