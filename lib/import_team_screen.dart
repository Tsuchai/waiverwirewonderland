import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiver_wire_wonderland/providers/waiver_wire_providers.dart';

class ImportTeamScreen extends ConsumerStatefulWidget {
  const ImportTeamScreen({super.key});

  @override
  ConsumerState<ImportTeamScreen> createState() => _ImportTeamScreenState();
}

class _ImportTeamScreenState extends ConsumerState<ImportTeamScreen> {
  final _leagueIdController = TextEditingController();

  @override
  void dispose() {
    _leagueIdController.dispose();
    super.dispose();
  }

  void _importLeague() {
    if (_leagueIdController.text.isNotEmpty) {
      ref.read(myLeagueProvider.notifier).fetchLeague(_leagueIdController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a League ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final myLeagueAsyncValue = ref.watch(myLeagueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import My Fantasy Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _leagueIdController,
              decoration: const InputDecoration(
                labelText: 'ESPN League ID',
                hintText: 'Enter your public league ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.cloud_download),
              label: const Text('Import League'),
              onPressed: _importLeague,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Expanded(
              child: myLeagueAsyncValue.when(
                data: (teams) {
                  if (teams.isEmpty) {
                    return const Center(child: Text('Enter a league ID to import your teams.'));
                  }
                  return ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(team.teamName),
                          subtitle: Text('Owner: ${team.owner}'),
                          trailing: Text('${team.players.length} players'),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    'Error: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
