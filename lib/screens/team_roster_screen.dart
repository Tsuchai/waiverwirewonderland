import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiver_wire_wonderland/models/player.dart';
import 'package:waiver_wire_wonderland/providers/waiver_wire_providers.dart';
import 'package:waiver_wire_wonderland/widgets/player_card.dart';

class TeamRosterScreen extends ConsumerStatefulWidget {
  final String teamAbbrev;
  final String teamName;

  const TeamRosterScreen({
    super.key,
    required this.teamAbbrev,
    required this.teamName,
  });

  @override
  ConsumerState<TeamRosterScreen> createState() => _TeamRosterScreenState();
}

class _TeamRosterScreenState extends ConsumerState<TeamRosterScreen> {
  bool _showAllPlayers = false;

  @override
  Widget build(BuildContext context) {
    final allPlayersAsync = ref.watch(allPlayersProvider);
    final myLeagueAsync = ref.watch(myLeagueProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CheckboxListTile(
              title: const Text('Show players on fantasy rosters'),
              value: _showAllPlayers,
              onChanged: (bool? value) {
                setState(() {
                  _showAllPlayers = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            ),
          ),
          Expanded(
            child: allPlayersAsync.when(
              data: (allPlayers) {
                // First, get all players for the selected NBA team.
                final teamPlayers = allPlayers.where((p) => p.team == widget.teamAbbrev).toList();

                return myLeagueAsync.when(
                  data: (myLeagueTeams) {
                    // Get all owned player IDs from the fantasy league.
                    final ownedPlayerIds = <int>{};
                    for (var team in myLeagueTeams) {
                      for (var player in team.players) {
                        ownedPlayerIds.add(player.playerId);
                      }
                    }

                    // Filter the team's players based on the checkbox.
                    final filteredPlayers = _showAllPlayers
                        ? teamPlayers
                        : teamPlayers.where((p) => !ownedPlayerIds.contains(p.playerId)).toList();
                    
                    if (filteredPlayers.isEmpty) {
                      return const Center(child: Text('No available players found for this team.'));
                    }

                    return ListView.builder(
                      itemCount: filteredPlayers.length,
                      itemBuilder: (context, index) {
                        // On this screen, the "add" button should always be visible.
                        return PlayerCard(player: filteredPlayers[index]);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Could not load fantasy league: $e')),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Could not load player database: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
