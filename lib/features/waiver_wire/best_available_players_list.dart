import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiver_wire_wonderland/providers/waiver_wire_providers.dart';
import 'package:waiver_wire_wonderland/widgets/player_card.dart';

class BestAvailablePlayersList extends ConsumerWidget {
  final bool showAllPlayers;

  const BestAvailablePlayersList({
    super.key,
    required this.showAllPlayers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlayers = ref.watch(allPlayersProvider);
    final asyncMyLeague = ref.watch(myLeagueProvider);

    return asyncPlayers.when(
      data: (players) {
        // Also handle the states for the fantasy league data
        return asyncMyLeague.when(
          data: (myLeagueTeams) {
            // Create a set of all player IDs that are on any fantasy team for efficient lookup.
            final ownedPlayerIds = <int>{};
            for (var team in myLeagueTeams) {
              for (var player in team.players) {
                ownedPlayerIds.add(player.playerId);
              }
            }

            // Filter the list of all players.
            final filteredPlayers = showAllPlayers
                ? players // If showAllPlayers is true, show everyone
                : players.where((player) => !ownedPlayerIds.contains(player.playerId)).toList(); // Otherwise, only show players NOT in the owned set.

            // Sort players by average points in descending order
            final sortedPlayers = [...filteredPlayers]; // Create a mutable copy
            sortedPlayers.sort((a, b) => b.avgPoints.compareTo(a.avgPoints));

            return ListView.builder(
              itemCount: sortedPlayers.length,
              itemBuilder: (context, index) {
                final player = sortedPlayers[index];
                return PlayerCard(player: player);
              },
            );
          },
          // Show a simplified loading/error state for the fantasy league data
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Could not load fantasy league to filter players: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
