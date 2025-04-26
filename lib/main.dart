import 'package:flutter/material.dart';
import 'package:ironroll/rolls_page.dart';
import 'package:ironroll/character_sheet_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironroll/widgets/oracle_tree.dart';
import 'models/track_data.dart';
import 'models/user.dart';
import 'models/quest.dart';
import 'services/character_service.dart';
import 'dart:convert'; // do jsonDecode
import 'package:flutter/services.dart' show rootBundle; // do rootBundle

late Map<String, dynamic> oraclesData;

Future<void> loadOracles() async {
  final String jsonString = await rootBundle.loadString('assets/oracles.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  oraclesData = jsonMap;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TrackDataAdapter());
  Hive.registerAdapter(StatNameAdapter());
  Hive.registerAdapter(StatAdapter());
  Hive.registerAdapter(CharacterAdapter());
  Hive.registerAdapter(QuestRankAdapter());
  Hive.registerAdapter(QuestAdapter());

  final characterService = CharacterService();
  await characterService.initialize();
  await loadOracles();

  runApp(MyApp(characterService: characterService));
}

class MyApp extends StatelessWidget {
  final CharacterService characterService;

  const MyApp({super.key, required this.characterService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IronRoll App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 76, 57, 145),
        ),
      ),
      home: MyHomePage(characterService: characterService),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CharacterService characterService;

  const MyHomePage({super.key, required this.characterService});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page = Placeholder();
    switch (selectedIndex) {
      case 0:
        page = RollsPage(characterService: widget.characterService);
      case 1:
        page = CharacterSheetPage(characterService: widget.characterService);
      case 2:
        page = OraclesTree(oraclesData: oraclesData);
    }
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.casino), label: 'Rolls'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Character'),
          NavigationDestination(icon: Icon(Icons.lightbulb), label: 'Oracles'),
        ],
      ),
    );
  }
}
