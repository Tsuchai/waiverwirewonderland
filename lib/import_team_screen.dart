import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImportTeamScreen extends ConsumerWidget {
  const ImportTeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import My Fantasy Team'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.cloud_download),
          label: const Text('Import from ESPN'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This feature is coming soon!'),
                backgroundColor: Colors.blue,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(250, 60),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
