import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waiver_wire_wonderland/models/fantasy_team.dart';
import 'package:waiver_wire_wonderland/models/player.dart';
import 'package:waiver_wire_wonderland/providers/waiver_wire_providers.dart';
import 'package:waiver_wire_wonderland/widgets/player_card.dart';

class ViewTeamScreen extends ConsumerStatefulWidget {
  const ViewTeamScreen({super.key});

  @override
  ConsumerState<ViewTeamScreen> createState() => _ViewTeamScreenState();
}

class _ViewTeamScreenState extends ConsumerState<ViewTeamScreen> {
  int? _selectedTeamIndex;
  String? _defaultTeamName;

  static const String _defaultTeamKey = 'defaultTeamName';

  @override
  void initState() {
    super.initState();
    _loadDefaultTeam();
  }

  Future<void> _loadDefaultTeam() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultTeamName = prefs.getString(_defaultTeamKey);
    });
  }

  Future<void> _saveDefaultTeam(String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultTeamKey, teamName);
    setState(() {
      _defaultTeamName = teamName;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$teamName set as your default team!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final myLeagueAsync = ref.watch(myLeagueProvider);
    final allPlayersAsync = ref.watch(allPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My League Teams'),
      ),
      body: myLeagueAsync.when(
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(
              child: Text(
                'No league data found.\nPlease import your league first.',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (_selectedTeamIndex == null) {
            final defaultTeamIndex = teams.indexWhere((team) => team.teamName == _defaultTeamName);
            _selectedTeamIndex = defaultTeamIndex != -1 ? defaultTeamIndex : 0;
          }

          final selectedTeam = teams[_selectedTeamIndex!];

          return Column(
            children: [
              _buildTeamSelector(teams, selectedTeam),
              const Divider(),
              Expanded(
                child: allPlayersAsync.when(
                  data: (allPlayers) {
                    final playerMap = {for (var p in allPlayers) p.playerId: p};
                    final roster = selectedTeam.players
                        .map((fantasyPlayer) => playerMap[fantasyPlayer.playerId])
                        .where((player) => player != null)
                        .cast<Player>()
                        .toList();

                    return ListView.builder(
                      itemCount: roster.length,
                      itemBuilder: (context, index) {
                        return PlayerCard(player: roster[index], showAddButton: false);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Error loading player database: $e')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading league: $e')),
      ),
    );
  }

  Widget _buildTeamSelector(List<FantasyTeam> teams, FantasyTeam selectedTeam) {
    final isDefault = selectedTeam.teamName == _defaultTeamName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<FantasyTeam>(
              value: selectedTeam,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: teams.map((team) {
                return DropdownMenuItem<FantasyTeam>(
                  value: team,
                  child: Text(team.teamName, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (FantasyTeam? newTeam) {
                if (newTeam != null) {
                  setState(() {
                    _selectedTeamIndex = teams.indexOf(newTeam);
                  });
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              isDefault ? Icons.star : Icons.star_border,
              color: isDefault ? Colors.amber : Colors.grey,
            ),
            onPressed: () => _saveDefaultTeam(selectedTeam.teamName),
            tooltip: 'Set as my default team',
          ),
        ],
      ),
    );
  }
}
