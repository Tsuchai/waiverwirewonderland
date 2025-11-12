import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:waiver_wire_wonderland/models/team_schedule.dart';
import 'package:waiver_wire_wonderland/providers/waiver_wire_providers.dart';
import 'package:waiver_wire_wonderland/widgets/team_schedule_card.dart';

class TeamScheduleList extends ConsumerWidget {
  final String selectedWeek;

  const TeamScheduleList({
    super.key,
    required this.selectedWeek,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullScheduleAsync = ref.watch(fullScheduleProvider);

    return fullScheduleAsync.when(
      data: (scheduleMap) {
        final schedules = scheduleMap[selectedWeek] ?? [];

        if (schedules.isEmpty) {
          return Center(child: Text('No schedule data for Week $selectedWeek.'));
        }

        final sortedSchedules = [...schedules];
        sortedSchedules.sort((a, b) => b.gamesThisWeek.compareTo(a.gamesThisWeek));

        // --- Calculate Date Range ---
        final firstGameDate = sortedSchedules.first.gameDates.first;
        DateTime getStartOfWeek(DateTime date) {
          int daysToSubtract = date.weekday - 1;
          return date.subtract(Duration(days: daysToSubtract));
        }
        final startOfWeek = getStartOfWeek(firstGameDate);
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        final weekRangeString =
            'Week of ${DateFormat.MMMd().format(startOfWeek)} - ${DateFormat.MMMd().format(endOfWeek)}, ${startOfWeek.year}';
        // --- End Calculate Date Range ---

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                weekRangeString,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sortedSchedules.length,
                itemBuilder: (context, index) {
                  final schedule = sortedSchedules[index];
                  return TeamScheduleCard(schedule: schedule);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}
