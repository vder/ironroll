import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironroll/widgets/vertical_track.dart';
import 'package:ironroll/widgets/stat_box.dart';
import 'package:ironroll/widgets/progress_track/progress_track_list.dart';
import 'package:ironroll/services/character_service.dart';

class CharacterSheetPage extends StatefulWidget {
  final CharacterService characterService;

  const CharacterSheetPage({super.key, required this.characterService});

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

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.characterService.stats.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
                child: ListView(
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Character Name',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) async {
                              await widget.characterService.updateName(value);
                              setState(() {});
                            },
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
                            StatBox(
                              label: 'EDGE',
                              value: widget.characterService.getStat('EDGE'),
                              onIncrement: () async {
                                await widget.characterService.incrementStat(
                                  'EDGE',
                                );
                                setState(() {});
                              },
                              onDecrement: () async {
                                await widget.characterService.decrementStat(
                                  'EDGE',
                                );
                                setState(() {});
                              },
                            ),
                            StatBox(
                              label: 'HEART',
                              value: widget.characterService.getStat('HEART'),
                              onIncrement: () async {
                                await widget.characterService.incrementStat(
                                  'HEART',
                                );
                                setState(() {});
                              },
                              onDecrement: () async {
                                await widget.characterService.decrementStat(
                                  'HEART',
                                );
                                setState(() {});
                              },
                            ),
                            StatBox(
                              label: 'IRON',
                              value: widget.characterService.getStat('IRON'),
                              onIncrement: () async {
                                await widget.characterService.incrementStat(
                                  'IRON',
                                );
                                setState(() {});
                              },
                              onDecrement: () async {
                                await widget.characterService.decrementStat(
                                  'IRON',
                                );
                                setState(() {});
                              },
                            ),
                            StatBox(
                              label: 'SHADOW',
                              value: widget.characterService.getStat('SHADOW'),
                              onIncrement: () async {
                                await widget.characterService.incrementStat(
                                  'SHADOW',
                                );
                                setState(() {});
                              },
                              onDecrement: () async {
                                await widget.characterService.decrementStat(
                                  'SHADOW',
                                );
                                setState(() {});
                              },
                            ),
                            StatBox(
                              label: 'WITS',
                              value: widget.characterService.getStat('WITS'),
                              onIncrement: () async {
                                await widget.characterService.incrementStat(
                                  'WITS',
                                );
                                setState(() {});
                              },
                              onDecrement: () async {
                                await widget.characterService.decrementStat(
                                  'WITS',
                                );
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    ConditionMeters(),
                    ProgressTrackList(),
                    const SizedBox(height: 16),
                    // Footer Controls
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
