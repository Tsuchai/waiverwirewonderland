import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiver_wire_wonderland/view_team_screen.dart';
import 'package:waiver_wire_wonderland/waiver_wire_screen.dart';

void main() {
  runApp(
    // Wrap the entire app in a ProviderScope to make Riverpod available.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waiver Wire Wonderland',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiver Wire Wonderland'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.waves),
              label: const Text('Waiver Wire'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WaiverWireScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('View My Team'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewTeamScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_upload),
              label: const Text('Import Team'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Import functionality coming soon!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
