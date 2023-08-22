import 'package:aubri/client.dart';
import 'package:flutter/material.dart';

import 'server.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppTabs(),
    );
  }
}

class AppTabs extends StatefulWidget {
  const AppTabs({super.key});
  @override
  State<AppTabs> createState() => TabState();
}

class TabState extends State<AppTabs> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aubri'),
      ),
      body: <Widget>[
        const ClientPage(),
        const ServerPage(),
      ][index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Player"),
          NavigationDestination(
            icon: Icon(Icons.cloud),
            label: 'Server',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }
}
