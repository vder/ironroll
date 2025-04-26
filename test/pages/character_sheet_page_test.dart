import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironroll/character_sheet_page.dart';
import 'package:ironroll/services/character_service.dart';
import 'package:ironroll/models/user.dart';
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

  group('CharacterSheetPage', () {
    testWidgets('displays character name field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CharacterSheetPage(characterService: characterService),
        ),
      );

      expect(find.text('Character Name'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('updates character name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CharacterSheetPage(characterService: characterService),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New Name');
      await tester.pump();

      expect(characterService.stats.name, equals('New Name'));
    });

    testWidgets('displays all stat boxes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CharacterSheetPage(characterService: characterService),
        ),
      );

      expect(find.text('EDGE'), findsOneWidget);
      expect(find.text('HEART'), findsOneWidget);
      expect(find.text('IRON'), findsOneWidget);
      expect(find.text('SHADOW'), findsOneWidget);
      expect(find.text('WITS'), findsOneWidget);
    });

    testWidgets('displays impact checkboxes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CharacterSheetPage(characterService: characterService),
        ),
      );

      expect(find.text('Wounded'), findsOneWidget);
      expect(find.text('Shaken'), findsOneWidget);
      expect(find.text('Unprepared'), findsOneWidget);
      expect(find.text('Permanently Harmed'), findsOneWidget);
      expect(find.text('Traumatized'), findsOneWidget);
      expect(find.text('Doomed'), findsOneWidget);
      expect(find.text('Tormented'), findsOneWidget);
      expect(find.text('Indebted'), findsOneWidget);
      expect(find.text('Battered'), findsOneWidget);
      expect(find.text('Cursed'), findsOneWidget);
    });

    testWidgets('displays vertical tracks', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CharacterSheetPage(characterService: characterService),
        ),
      );

      expect(find.text('Momentum'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('Spirit'), findsOneWidget);
      expect(find.text('Supply'), findsOneWidget);
    });
  });
}
