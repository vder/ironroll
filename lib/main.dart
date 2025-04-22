import 'package:flutter/material.dart';
import 'package:ironroll/rolls_page.dart';
import 'package:ironroll/character_sheet_page.dart';
import 'package:provider/provider.dart';
import 'package:ironroll/providers/character_stats_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/track_data.dart';
import 'models/user.dart';
import 'models/quest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TrackDataAdapter());
  Hive.registerAdapter(StatNameAdapter());
  Hive.registerAdapter(StatAdapter());
  Hive.registerAdapter(CharacterAdapter());
  Hive.registerAdapter(QuestRankAdapter());
  Hive.registerAdapter(QuestAdapter());
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CharacterProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
        page = RollsPage();
      case 1:
        page = CharacterSheetPage();
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
        ],
      ),
    );
  }
}
