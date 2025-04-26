import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironroll/services/character_service.dart';
import 'package:ironroll/models/user.dart';

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

  group('CharacterService', () {
    test('initializes with default character', () {
      expect(characterService.stats.name, equals('John Doe'));
      expect(characterService.getStat('EDGE'), equals(2));
      expect(characterService.getStat('HEART'), equals(2));
      expect(characterService.getStat('IRON'), equals(1));
      expect(characterService.getStat('SHADOW'), equals(1));
      expect(characterService.getStat('WITS'), equals(3));
    });

    test('updates character name', () async {
      await characterService.updateName('New Name');
      expect(characterService.stats.name, equals('New Name'));
    });

    test('updates stats', () async {
      await characterService.updateStat('EDGE', 3);
      expect(characterService.getStat('EDGE'), equals(3));
    });

    test('increments stats', () async {
      final initialValue = characterService.getStat('EDGE');
      await characterService.incrementStat('EDGE');
      expect(characterService.getStat('EDGE'), equals(initialValue + 1));
    });

    test('does not increment stats above 5', () async {
      await characterService.updateStat('EDGE', 5);
      await characterService.incrementStat('EDGE');
      expect(characterService.getStat('EDGE'), equals(5));
    });

    test('decrements stats', () async {
      final initialValue = characterService.getStat('EDGE');
      await characterService.decrementStat('EDGE');
      expect(characterService.getStat('EDGE'), equals(initialValue - 1));
    });

    test('does not decrement stats below 0', () async {
      await characterService.updateStat('EDGE', 0);
      await characterService.decrementStat('EDGE');
      expect(characterService.getStat('EDGE'), equals(0));
    });

    test('persists changes', () async {
      await characterService.updateName('Test Name');
      await characterService.updateStat('EDGE', 4);

      // Create a new instance to test persistence
      final newService = CharacterService();
      await newService.initialize();

      expect(newService.stats.name, equals('Test Name'));
      expect(newService.getStat('EDGE'), equals(4));
    });
  });
}
