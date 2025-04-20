import 'package:flutter/material.dart';
import 'package:ironroll/model/quest.dart';
import 'package:ironroll/widgets/progress_track/progress_track.dart';

class ProgressTrackList extends StatefulWidget {
  const ProgressTrackList({Key? key}) : super(key: key);

  @override
  State<ProgressTrackList> createState() => _ProgressTrackListState();
}

class _ProgressTrackListState extends State<ProgressTrackList> {
  final List<Quest> _quests = [];
  final TextEditingController _nameController = TextEditingController();
  QuestRank _selectedRank = QuestRank.troublesome;

  void _addQuest() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _quests.add(Quest(name, _selectedRank));
      _nameController.clear();
      _selectedRank = QuestRank.troublesome;
    });
  }

  void _removeQuest(int index) {
    setState(() {
      _quests.removeAt(index);
    });
  }

  void _updateQuest(int index, Quest updated) {
    setState(() {
      _quests[index] = updated;
    });
  }

  void _reorderQuests(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final quest = _quests.removeAt(oldIndex);
      _quests.insert(newIndex, quest);
    });
  }

  String _getRankLabel(QuestRank rank) {
    return rank.name[0].toUpperCase() + rank.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Quest Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<QuestRank>(
                value: _selectedRank,
                onChanged: (rank) {
                  if (rank != null) {
                    setState(() => _selectedRank = rank);
                  }
                },
                items:
                    QuestRank.values.map((rank) {
                      return DropdownMenuItem(
                        value: rank,
                        child: Text(_getRankLabel(rank)),
                      );
                    }).toList(),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _addQuest,
                icon: const Icon(Icons.add),
                label: const Text("Add"),
              ),
            ],
          ),
        ),

        // ✅ Scrollable and reorderable quest list
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: _quests.length,
            onReorder: _reorderQuests,
            itemBuilder: (context, index) {
              final quest = _quests[index];

              return Card(
                key: ValueKey(quest),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProgressTrack(
                              quest: quest,
                              onChanged:
                                  (updatedQuest) =>
                                      _updateQuest(index, updatedQuest),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeQuest(index),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
