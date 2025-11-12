import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import for ConsumerWidget
import 'package:waiver_wire_wonderland/features/waiver_wire/best_available_players_list.dart';
import 'package:waiver_wire_wonderland/features/waiver_wire/team_schedule_list.dart';

enum WaiverViewMode { bestAvailable, teamSchedule }

class WaiverWireScreen extends StatefulWidget {
  const WaiverWireScreen({super.key});

  @override
  State<WaiverWireScreen> createState() => _WaiverWireScreenState();
}

class _WaiverWireScreenState extends State<WaiverWireScreen> {
  WaiverViewMode _selectedMode = WaiverViewMode.bestAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiver Wire'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<WaiverViewMode>(
              segments: const [
                ButtonSegment(
                  value: WaiverViewMode.bestAvailable,
                  label: Text('Best Available'),
                  icon: Icon(Icons.star),
                ),
                ButtonSegment(
                  value: WaiverViewMode.teamSchedule,
                  label: Text('Weekly Schedule'),
                  icon: Icon(Icons.calendar_today),
                ),
              ],
              selected: {_selectedMode},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedMode = newSelection.first;
                });
              },
              style: SegmentedButton.styleFrom(
                // Ensure the button takes available width
                // This might require wrapping in a Row with MainAxisAlignment.spaceAround
                // or adjusting constraints if needed for full width.
              ),
            ),
          ),
          Expanded(
            child: _selectedMode == WaiverViewMode.bestAvailable
                ? const BestAvailablePlayersList()
                : const TeamScheduleList(),
          ),
        ],
      ),
    );
  }
}
