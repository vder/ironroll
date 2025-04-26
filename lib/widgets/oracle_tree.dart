import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OraclesTree extends StatefulWidget {
  final Map<String, dynamic> oraclesData;

  const OraclesTree({super.key, required this.oraclesData});

  @override
  State<OraclesTree> createState() => _OraclesTreeState();
}

class _OraclesTreeState extends State<OraclesTree> {
  final Map<String, String> _rolledResults = {};
  final List<Map<String, dynamic>> _oracleRollables = [];
  final Map<String, dynamic> _oracleTree = {};
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _expandedPaths = {};

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _findAllRollableOracles(widget.oraclesData['oracles']);
    _buildOracleTree();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _findAllRollableOracles(
    Map<String, dynamic> node, [
    String parentPath = '',
  ]) {
    node.forEach((key, value) {
      if (key == 'contents' || key == 'collections') {
        if (value is Map) {
          _findAllRollableOracles(Map<String, dynamic>.from(value), parentPath);
        } else if (value is List) {
          for (var item in value) {
            if (item is Map) {
              _findAllRollableOracles(
                Map<String, dynamic>.from(item),
                parentPath,
              );
            }
          }
        }
      } else {
        if (value is Map) {
          final mapValue = Map<String, dynamic>.from(value);
          if (mapValue['type'] == 'oracle_rollable' &&
              mapValue.containsKey('rows')) {
            _oracleRollables.add({
              'path': parentPath.isEmpty ? key : '$parentPath/$key',
              'name': mapValue['name'] ?? key,
              'rows': mapValue['rows'],
              'dice': mapValue['dice'] ?? '1d100',
            });
          } else {
            _findAllRollableOracles(
              mapValue,
              parentPath.isEmpty ? key : '$parentPath/$key',
            );
          }
        } else if (value is List) {
          for (var item in value) {
            if (item is Map) {
              _findAllRollableOracles(
                Map<String, dynamic>.from(item),
                parentPath.isEmpty ? key : '$parentPath/$key',
              );
            }
          }
        }
      }
    });
  }

  void _buildOracleTree() {
    for (var oracle in _oracleRollables) {
      final parts = (oracle['path'] as String).split('/');
      Map<String, dynamic> current = _oracleTree;

      for (var i = 0; i < parts.length; i++) {
        final part = parts[i];
        if (i == parts.length - 1) {
          current[part] = oracle;
        } else {
          current =
              current.putIfAbsent(part, () => <String, dynamic>{})
                  as Map<String, dynamic>;
        }
      }
    }
  }

  void _updateExpandedPaths() {
    _expandedPaths.clear();

    if (_searchQuery.isEmpty) return;

    final lowerQuery = _searchQuery.toLowerCase();

    for (final oracle in _oracleRollables) {
      final path = oracle['path'] as String;
      final name = oracle['name'] as String;

      if (path.toLowerCase().contains(lowerQuery) ||
          name.toLowerCase().contains(lowerQuery)) {
        final parts = path.split('/');
        String accumulated = '';
        for (var part in parts.take(parts.length - 1)) {
          accumulated = accumulated.isEmpty ? part : '$accumulated/$part';
          _expandedPaths.add(accumulated);
        }
      }
    }
  }

  Map<String, dynamic> _buildFilteredTree() {
    final lowerQuery = _searchQuery.toLowerCase();
    final Map<String, dynamic> filteredTree = {};

    for (final oracle in _oracleRollables) {
      final path = oracle['path'] as String;
      final name = oracle['name'] as String;

      if (path.toLowerCase().contains(lowerQuery) ||
          name.toLowerCase().contains(lowerQuery)) {
        final parts = path.split('/');
        Map<String, dynamic> current = filteredTree;

        for (var i = 0; i < parts.length; i++) {
          final part = parts[i];
          if (i == parts.length - 1) {
            current[part] = oracle;
          } else {
            current =
                current.putIfAbsent(part, () => <String, dynamic>{})
                    as Map<String, dynamic>;
          }
        }
      }
    }

    return filteredTree;
  }

  @override
  Widget build(BuildContext context) {
    final showingTree =
        _searchQuery.isNotEmpty ? _buildFilteredTree() : _oracleTree;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Szukaj oracla...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _updateExpandedPaths();
              });
            },
          ),
        ),
        Expanded(child: ListView(children: _buildTree(showingTree))),
      ],
    );
  }

  List<Widget> _buildTree(
    Map<String, dynamic> node, [
    String parentPath = '',
    int depth = 0,
  ]) {
    List<Widget> widgets = [];

    node.forEach((key, value) {
      final currentPath = parentPath.isEmpty ? key : '$parentPath/$key';

      if (value is Map<String, dynamic> &&
          !(value.containsKey('path') && value.containsKey('rows'))) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: 16.0 * depth),
            child: ExpansionTile(
              title: Row(
                children: [
                  const Icon(Icons.folder),
                  const SizedBox(width: 8),
                  Text(
                    key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              initiallyExpanded: _expandedPaths.contains(currentPath),
              children: _buildTree(value, currentPath, depth + 1),
            ),
          ),
        );
      } else if (value is Map<String, dynamic>) {
        widgets.add(_buildOracleTile(value, depth));
      }
    });

    return widgets;
  }

  Widget _buildOracleTile(Map<String, dynamic> oracle, int depth) {
    final oraclePath = oracle['path'];
    final oracleName = oracle['name'];
    final rows = oracle['rows'];

    return Padding(
      padding: EdgeInsets.only(left: 16.0 * depth),
      child: ListTile(
        title: Row(
          children: [
            const Icon(Icons.casino),
            const SizedBox(width: 8),
            Expanded(child: Text(oracleName)),
            IconButton(
              icon: const Icon(Icons.casino),
              tooltip: 'Rzuć kością',
              onPressed: () => _rollAndShow(oraclePath, rows),
            ),
          ],
        ),
        subtitle:
            _rolledResults.containsKey(oraclePath)
                ? Text(_rolledResults[oraclePath]!)
                : null,
      ),
    );
  }

  void _rollAndShow(String oracleKey, List<dynamic> rows) {
    final random = Random();

    final oracle = _oracleRollables.firstWhere(
      (o) => o['path'] == oracleKey,
      orElse: () => {},
    );

    final dice = (oracle['dice'] ?? '1d100') as String;
    final diceSides = _parseDiceSides(dice);

    List nonEmptyRows =
        rows
            .where(
              (row) =>
                  row.containsKey('min') &&
                  row.containsKey('max') &&
                  row['min'] != null &&
                  row['max'] != null,
            )
            .toList();

    int roll;
    Map<String, dynamic> randomRow;

    roll = random.nextInt(diceSides) + 1;

    if (nonEmptyRows.isNotEmpty) {
      randomRow = nonEmptyRows.firstWhere((row) {
        final min = row['min'] ?? 0;
        final max = row['max'] ?? 0;
        return roll >= min && roll <= max;
      }, orElse: () => {'text': 'Brak wyniku', 'text2': ''});
    } else {
      if (roll <= rows.length) {
        randomRow = rows[roll - 1];
      } else {
        randomRow = rows.last;
      }
    }

    final textRaw = randomRow['text'] ?? 'Brak tekstu';
    final text2Raw = randomRow['text2'] ?? '';

    String formatText(String input) {
      final matches = RegExp(r'\[([^\]]+)\]').allMatches(input);
      final extracted = matches.map((m) => m.group(1)!).toList();
      if (extracted.isNotEmpty) {
        return extracted.join(', ');
      } else {
        return input;
      }
    }

    final text = formatText(textRaw);
    final text2 = text2Raw.isNotEmpty ? formatText(text2Raw) : '';

    final result = text2.isNotEmpty ? '$text\n$text2' : text;

    setState(() {
      _rolledResults[oracleKey] = '[$roll] $result';
    });

    Clipboard.setData(ClipboardData(text: result));
  }

  int _parseDiceSides(String dice) {
    final match = RegExp(r'1d(\d+)').firstMatch(dice);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 100;
    }
    return 100;
  }
}
