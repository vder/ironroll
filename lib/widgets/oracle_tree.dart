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
  final Map<String, String> _rolledResults = {}; // Wyniki losowań
  final List<Map<String, dynamic>> _oracleRollables =
      []; // Wszystkie znalezione oracles
  final Map<String, dynamic> _oracleTree =
      {}; // Drzewo oracle na podstawie path

  @override
  void initState() {
    super.initState();
    _findAllRollableOracles(widget.oraclesData["oracles"]);
    _buildOracleTree();
  }

  void _findAllRollableOracles(
    Map<String, dynamic> node, [
    String parentPath = '',
  ]) {
    node.forEach((key, value) {
      if (key == 'contents' || key == 'collections') {
        // Pomiń 'contents' i 'collections' w ścieżkach
        if (value is Map) {
          final mapValue = Map<String, dynamic>.from(value);
          _findAllRollableOracles(
            mapValue,
            parentPath,
          ); // Nie zmieniaj parentPath
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
          current[part] = oracle; // Na końcu wstawiamy oracle (plik)
        } else {
          current =
              current.putIfAbsent(part, () => <String, dynamic>{})
                  as Map<String, dynamic>;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: _buildTree(_oracleTree));
  }

  List<Widget> _buildTree(Map<String, dynamic> node) {
    List<Widget> widgets = [];

    node.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          !(value.containsKey('path') && value.containsKey('rows'))) {
        // Jeśli to folder, robimy ExpansionTile
        widgets.add(
          ExpansionTile(
            title: Row(
              children: [
                const Icon(Icons.folder),
                const SizedBox(width: 8),
                Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            children: _buildTree(value),
          ),
        );
      } else if (value is Map<String, dynamic>) {
        // Jeśli to oracle do losowania
        final oraclePath = value['path'];
        final oracleName = value['name'];
        final rows = value['rows'];

        widgets.add(
          ListTile(
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
    });

    return widgets;
  }

  void _rollAndShow(String oracleKey, List<dynamic> rows) {
    final random = Random();

    // Znajdujemy oracle, żeby pobrać dice
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

    // Oracle z min/max: losowanie 1-dice i szukanie wiersza min/max
    roll = random.nextInt(diceSides) + 1;

    randomRow = nonEmptyRows.firstWhere((row) {
      final min = row['min'] ?? 0;
      final max = row['max'] ?? 0;
      return roll >= min && roll <= max;
    }, orElse: () => {'text': 'Brak wyniku', 'text2': ''});

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

  /// Pomocnicza funkcja - parsujemy ile ścianek ma kostka np. "1d100" -> 100
  int _parseDiceSides(String dice) {
    final match = RegExp(r'1d(\d+)').firstMatch(dice);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 100;
    }
    return 100;
  }
}
