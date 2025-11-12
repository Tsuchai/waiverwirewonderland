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
        return asyncMyLeague.when(
          data: (myLeagueTeams) {
            final ownedPlayerIds = <int>{};
            for (var team in myLeagueTeams) {
              for (var player in team.players) {
                ownedPlayerIds.add(player.playerId);
              }
            }

            final filteredPlayers = showAllPlayers
                ? players // If showAllPlayers is true, show everyone
                : players.where((player) => !ownedPlayerIds.contains(player.playerId)).toList();

            // Sort players by average points in descending order, need to change to more advanced search algorithm later
            final sortedPlayers = [...filteredPlayers];
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
          error: (err, stack) => Center(child: Text('Could not load fantasy league to filter players: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
