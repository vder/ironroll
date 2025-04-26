import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OraclesTree extends StatefulWidget {
  final Map<String, dynamic> oraclesData;

  const OraclesTree({super.key, required this.oraclesData});

  @override
  State<OraclesTree> createState() => _OraclesTreeState();
}

class _OraclesTreeState extends State<OraclesTree>
    with SingleTickerProviderStateMixin {
  final Map<String, String> _rolledResults = {}; // zapamiętujemy wyniki losowań
  String? _expandedOracleKey; // aktualnie rozwinięta gałąź

  @override
  Widget build(BuildContext context) {
    final oracles = widget.oraclesData['oracles'] as Map<String, dynamic>;

    return ListView(
      children:
          oracles.entries.map((oracleEntry) {
            final oracleKey = oracleEntry.key;
            final isExpanded = _expandedOracleKey == oracleKey;

            return _buildCustomExpansionTile(
              oracleKey: oracleKey,
              oracleName: oracleEntry.value['name'] ?? oracleKey,
              isExpanded: isExpanded,
              children: _buildContents(
                context,
                oracleEntry.value['contents'],
                oracleKey,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCustomExpansionTile({
    required String oracleKey,
    required String oracleName,
    required bool isExpanded,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            oracleName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              if (_expandedOracleKey == oracleKey) {
                _expandedOracleKey =
                    null; // zamknij jeśli kliknięty był otwarty
              } else {
                _expandedOracleKey = oracleKey; // otwórz nowy
              }
            });
          },
        ),
        AnimatedCrossFade(
          firstChild: SizedBox.shrink(),
          secondChild: Column(children: children),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }

  List<Widget> _buildContents(
    BuildContext context,
    Map<String, dynamic>? contents,
    String oracleKey,
  ) {
    if (contents == null) return [Text('Brak danych')];

    return contents.entries.map((contentEntry) {
      final contentKey = '$oracleKey-${contentEntry.key}';
      final rows = contentEntry.value['rows'];

      return Padding(
        padding: const EdgeInsets.only(
          left: 32.0,
        ), // <-- dodane wcięcie dla niższego poziomu
        child: ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(contentEntry.value['name'] ?? contentEntry.key),
              ),
              IconButton(
                icon: Icon(Icons.casino),
                tooltip: 'Rzuć kością',
                onPressed: () => _rollAndShow(contentKey, rows),
              ),
            ],
          ),
          subtitle:
              _rolledResults.containsKey(contentKey)
                  ? Text(_rolledResults[contentKey]!)
                  : null,
        ),
      );
    }).toList();
  }

  void _rollAndShow(String contentKey, List<dynamic> rows) {
    final random = Random();
    final randomRow = rows[random.nextInt(rows.length)];

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
      _rolledResults[contentKey] = result;
    });

    // Kopiowanie do schowka
    Clipboard.setData(ClipboardData(text: result));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎲 Wylosowano i skopiowano: $text'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }
}
