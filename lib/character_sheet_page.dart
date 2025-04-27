import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironroll/widgets/condition_meters.dart';
import 'package:ironroll/widgets/stat_card.dart';
import 'package:ironroll/widgets/progress_track/progress_track_list.dart';
import 'package:ironroll/services/character_service.dart';

class CharacterSheetPage extends StatefulWidget {
  final CharacterService characterService;

  const CharacterSheetPage({super.key, required this.characterService});

  @override
  State<CharacterSheetPage> createState() => _CharacterSheetPageState();
}

class _CharacterSheetPageState extends State<CharacterSheetPage> {
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
    var children = [
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
      StatCard(
        characterService: widget.characterService,
        onChanged: () => setState(() {}),
      ),
      ConditionMeters(),
      ProgressTrackList(),
    ];
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
          padding: const EdgeInsets.all(8.0).copyWith(left: 24),
          child: Row(children: [Expanded(child: ListView(children: children))]),
        ),
      ),
    );
  }
}
