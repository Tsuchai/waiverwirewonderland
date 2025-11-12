import 'package:flutter/material.dart';
import 'package:waiver_wire_wonderland/models/player.dart';
import 'package:intl/intl.dart'; // For date formatting

class PlayerDetailScreen extends StatelessWidget {
  final Player player;

  const PlayerDetailScreen({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: player.imageUrl.isNotEmpty ? NetworkImage(player.imageUrl) : null,
                    child: player.imageUrl.isEmpty ? Text(player.name.substring(0, 1), style: const TextStyle(fontSize: 30)) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${player.team} - ${player.position.join(', ')}',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text('Jersey: ${player.jerseyNumber}', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Season Averages',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            _buildSeasonAveragesGrid(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Recent Game Log',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            if (player.gameLog.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No recent game data available.'),
              )
            else
              ListView.builder(
                shrinkWrap: true, // Important for nested ListViews
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling for nested ListView
                itemCount: player.gameLog.length,
                itemBuilder: (context, index) {
                  final game = player.gameLog[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateFormat.yMMMd().format(game.date)} vs. ${game.opponent}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatColumn('MIN', game.minutes.toStringAsFixed(1)),
                              _buildStatColumn('PTS', game.points.toString()),
                              _buildStatColumn('REB', game.rebounds.toString()),
                              _buildStatColumn('AST', game.assists.toString()),
                              _buildStatColumn('STL', game.steals.toString()),
                              _buildStatColumn('BLK', game.blocks.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16), // Add some space at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonAveragesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        children: [
          _buildStatItem('PTS', player.avgPoints),
          _buildStatItem('REB', player.avgRebounds),
          _buildStatItem('AST', player.avgAssists),
          _buildStatItem('STL', player.avgSteals),
          _buildStatItem('BLK', player.avgBlocks),
          _buildStatItem('TO', player.avgTurnovers),
          _buildStatItem('FG%', player.avgFieldGoalPercentage * 100),
          _buildStatItem('FT%', player.avgFreeThrowPercentage * 100),
          _buildStatItem('3PM', player.avgThreePointersMade),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1), // Show 0 decimal if whole number, else 1
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
