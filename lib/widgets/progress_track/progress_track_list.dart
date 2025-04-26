import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironroll/models/quest.dart';
import 'package:ironroll/widgets/progress_track/progress_track.dart';

class ProgressTrackList extends StatefulWidget {
  ProgressTrackList({super.key});

  @override
  State<ProgressTrackList> createState() => _ProgressTrackListState();
}

class _ProgressTrackListState extends State<ProgressTrackList> {
  late Future<Box<Quest>> _futureQuestBox;
  final TextEditingController _nameController = TextEditingController();
  QuestRank _selectedRank = QuestRank.troublesome;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    _futureQuestBox = Hive.openBox<Quest>('quests');
  }

  void _addQuest(Box<Quest> questBox) {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final quest = Quest(name: name, rank: _selectedRank);
    questBox.add(quest);
    setState(() {
      _nameController.clear();
      _selectedRank = QuestRank.troublesome;
    });
  }

  void _removeQuest(Box<Quest> questBox, int index) {
    questBox.deleteAt(index);
    setState(() {});
  }

  void _updateQuest(Box<Quest> questBox, int index, Quest updated) {
    questBox.putAt(index, updated);
    setState(() {});
  }

  Future<void> _reorderQuests(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;

    final questBox = await _futureQuestBox; // wait for the box to be ready

    final quests = questBox.values.toList(); // copy quests
    final quest = quests.removeAt(oldIndex); // remove old
    quests.insert(newIndex, quest); // insert at new position

    await questBox.clear(); // clear the box
    await questBox.addAll(quests); // write reordered quests

    setState(() {}); // rebuild the UI
  }

  String _getRankLabel(QuestRank rank) {
    return rank.name[0].toUpperCase() + rank.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<Quest>>(
      future: _futureQuestBox,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final questBox = snapshot.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                SizedBox(
                  height: 2 * 178 + 112,
                  child: Column(
                    children: [
                      // Input row
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Quest Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Row(
                              children: [
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
                                          child: Text(
                                            _getRankLabel(rank),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final box =
                                        await _futureQuestBox; // wait until box is ready
                                    _addQuest(box); // now you can add
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("Add"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Scrollable and reorderable quest list
                      Expanded(
                        child: ValueListenableBuilder<Box<Quest>>(
                          valueListenable: questBox.listenable(),
                          builder: (context, box, _) {
                            return ReorderableListView.builder(
                              buildDefaultDragHandles: false,
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: box.length,
                              onReorder: _reorderQuests,
                              itemBuilder: (context, index) {
                                final quest = box.getAt(index)!;

                                return Card(
                                  key: ValueKey(quest),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            // Display quest name with drag functionality
                                            Container(
                                              constraints: const BoxConstraints(
                                                maxWidth: 200,
                                              ),
                                              child:
                                                  ReorderableDragStartListener(
                                                    index: index,
                                                    child: Text(
                                                      quest.name,
                                                      softWrap: true,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                final box =
                                                    await _futureQuestBox; // wait until box is ready
                                                _removeQuest(
                                                  box,
                                                  index,
                                                ); // now you can add
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // Pass only the progress-related data to ProgressTrack
                                            ProgressTrack(
                                              quest: quest,
                                              onChanged:
                                                  (updatedQuest) =>
                                                      _updateQuest(
                                                        questBox,
                                                        index,
                                                        updatedQuest,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
