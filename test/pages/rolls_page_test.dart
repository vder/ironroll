import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironroll/rolls_page.dart';
import 'package:ironroll/services/character_service.dart';
import 'package:ironroll/models/user.dart';
import 'package:ironroll/widgets/roll_result_card.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  late CharacterService characterService;

  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StatNameAdapter());
    Hive.registerAdapter(StatAdapter());
    Hive.registerAdapter(CharacterAdapter());
  });

  setUp(() async {
    characterService = CharacterService();
    await characterService.initialize();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('character');
  });

  group('RollsPage', () {
    testWidgets('displays character name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RollsPage(characterService: characterService)),
      );

      expect(find.text('Character: John Doe'), findsOneWidget);
    });

    testWidgets('displays action and oracle roll buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: RollsPage(characterService: characterService)),
      );

      expect(find.text('Action Roll'), findsOneWidget);
      expect(find.text('Oracle Roll'), findsOneWidget);
    });

    testWidgets('displays stat selection chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RollsPage(characterService: characterService)),
      );

      expect(find.text('EDGE'), findsOneWidget);
      expect(find.text('HEART'), findsOneWidget);
      expect(find.text('IRON'), findsOneWidget);
      expect(find.text('SHADOW'), findsOneWidget);
      expect(find.text('WITS'), findsOneWidget);
    });

    testWidgets('performs action roll', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RollsPage(characterService: characterService)),
      );

      // Select a stat
      await tester.tap(find.text('EDGE'));
      await tester.pump();

      // Perform action roll
      await tester.tap(find.text('Action Roll'));
      await tester.pump();

      // Verify roll result card is displayed
      expect(find.byType(RollResultCard), findsOneWidget);
    });

    testWidgets('performs oracle roll', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RollsPage(characterService: characterService)),
      );

      // Perform oracle roll
      await tester.tap(find.text('Oracle Roll'));
      await tester.pump();

      // Verify d100 roll result card is displayed
      expect(find.byType(RollResultCard), findsOneWidget);
    });

    testWidgets('toggles between action and oracle rolls', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: RollsPage(characterService: characterService)),
      );

      // Perform action roll
      await tester.tap(find.text('Action Roll'));
      await tester.pump();
      expect(find.byType(RollResultCard), findsOneWidget);

      // Perform oracle roll
      await tester.tap(find.text('Oracle Roll'));
      await tester.pump();
      expect(find.byType(RollResultCard), findsOneWidget);
    });
  });
}
