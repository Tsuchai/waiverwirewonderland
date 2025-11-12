import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiver_wire_wonderland/providers/waiver_wire_providers.dart';
import 'package:waiver_wire_wonderland/widgets/player_card.dart';

class BestAvailablePlayersList extends ConsumerWidget {
  const BestAvailablePlayersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlayers = ref.watch(allPlayersProvider);

    return asyncPlayers.when(
      data: (players) {
        // Sort players by average points in descending order
        final sortedPlayers = [...players]; // Create a mutable copy
        sortedPlayers.sort((a, b) => b.avgPoints.compareTo(a.avgPoints));

        return ListView.builder(
          itemCount: sortedPlayers.length,
          itemBuilder: (context, index) {
            final player = sortedPlayers[index];
            return PlayerCard(player: player);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
