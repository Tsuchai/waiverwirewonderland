import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiver_wire_wonderland/features/waiver_wire/best_available_players_list.dart';
import 'package:waiver_wire_wonderland/features/waiver_wire/team_schedule_list.dart';
import 'package:waiver_wire_wonderland/providers/waiver_wire_providers.dart';

enum WaiverViewMode { bestAvailable, teamSchedule }

class WaiverWireScreen extends ConsumerStatefulWidget {
  const WaiverWireScreen({super.key});

  @override
  ConsumerState<WaiverWireScreen> createState() => _WaiverWireScreenState();
}

class _WaiverWireScreenState extends ConsumerState<WaiverWireScreen> {
  WaiverViewMode _selectedMode = WaiverViewMode.bestAvailable;
  bool _showAllPlayers = false;
  String _selectedWeek = '1'; // Default to week 1

  @override
  Widget build(BuildContext context) {
    final fullScheduleAsync = ref.watch(fullScheduleProvider);

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
            ),
          ),
          // Conditional controls based on view mode
          if (_selectedMode == WaiverViewMode.bestAvailable)
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
          if (_selectedMode == WaiverViewMode.teamSchedule)
            fullScheduleAsync.when(
              data: (scheduleMap) {
                final weeks = scheduleMap.keys.toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    value: _selectedWeek,
                    isExpanded: true,
                    items: weeks.map((week) {
                      return DropdownMenuItem(
                        value: week,
                        child: Text('Week $week'),
                      );
                    }).toList(),
                    onChanged: (String? newWeek) {
                      if (newWeek != null) {
                        setState(() {
                          _selectedWeek = newWeek;
                        });
                      }
                    },
                  ),
                );
              },
              loading: () => const SizedBox.shrink(), // Don't show anything while loading schedule for dropdown
              error: (e, s) => Text('Error loading schedule: $e'),
            ),
          Expanded(
            child: _selectedMode == WaiverViewMode.bestAvailable
                ? BestAvailablePlayersList(showAllPlayers: _showAllPlayers)
                : TeamScheduleList(selectedWeek: _selectedWeek), // Pass the selected week
          ),
        ],
      ),
    );
  }
}
