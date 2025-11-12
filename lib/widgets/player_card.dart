import 'package:flutter/material.dart';
import 'package:waiver_wire_wonderland/models/player.dart';
import 'package:waiver_wire_wonderland/screens/player_detail_screen.dart'; // Import the new screen

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool showAddButton;

  const PlayerCard({
    super.key,
    required this.player,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector( // Wrap with GestureDetector for tap detection
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerDetailScreen(player: player),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: player.imageUrl.isNotEmpty ? NetworkImage(player.imageUrl) : null,
                child: player.imageUrl.isEmpty ? Text(player.name.substring(0, 1)) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${player.team} - ${player.position.join(', ')}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatColumn('PTS', player.avgPoints),
                        _buildStatColumn('REB', player.avgRebounds),
                        _buildStatColumn('AST', player.avgAssists),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (showAddButton)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 30),
                  onPressed: () {
                    // Handle adding player to team - this will be implemented next
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Add ${player.name} to team (not yet implemented)')),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value.toStringAsFixed(1),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
