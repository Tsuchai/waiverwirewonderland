import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiver_wire_wonderland/features/waiver_wire/best_available_players_list.dart';
import 'package:waiver_wire_wonderland/features/waiver_wire/team_schedule_list.dart';
import 'package:waiver_wire_wonderland/models/team_schedule.dart';
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
  void initState() {
    super.initState();
    _initializeSelectedWeek();
  }

  void _initializeSelectedWeek() async {
    final scheduleMap = await ref.read(fullScheduleProvider.future);
    if (mounted) {
      setState(() {
        _selectedWeek = _getCurrentWeek(scheduleMap);
      });
    }
  }

  String _getCurrentWeek(Map<String, List<TeamSchedule>> scheduleMap) {
    final now = DateTime.now();
    String currentWeek = '1'; // Default to week 1 if no matching week is found

    final sortedWeeks = scheduleMap.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    for (final week in sortedWeeks) {
      final teamSchedules = scheduleMap[week];
      if (teamSchedules != null) {
        // Check if any game date in this week is on or after today
        final hasFutureGame = teamSchedules.any((teamSchedule) {
          return teamSchedule.gameDates.any((gameDate) {
            // Compare only date parts, ignore time
            return gameDate.year == now.year &&
                gameDate.month == now.month &&
                gameDate.day == now.day ||
                gameDate.isAfter(now);
          });
        });

        if (hasFutureGame) {
          currentWeek = week;
          break;
        }
      }
    }
    return currentWeek;
  }

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
              loading: () => const SizedBox.shrink(),
              error: (e, s) => Text('Error loading schedule: $e'),
            ),
          Expanded(
            child: _selectedMode == WaiverViewMode.bestAvailable
                ? BestAvailablePlayersList(showAllPlayers: _showAllPlayers)
                : TeamScheduleList(selectedWeek: _selectedWeek),
          ),
        ],
      ),
    );
  }
}
