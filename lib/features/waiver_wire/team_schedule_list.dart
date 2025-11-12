import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waiver_wire_wonderland/providers/waiver_wire_providers.dart';
import 'package:waiver_wire_wonderland/widgets/team_schedule_card.dart';

class TeamScheduleList extends ConsumerWidget {
  const TeamScheduleList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(teamSchedulesProvider);

    // Sort schedules by gamesThisWeek in descending order
    final sortedSchedules = [...schedules]; // Create a mutable copy
    sortedSchedules.sort((a, b) => b.gamesThisWeek.compareTo(a.gamesThisWeek));

    return ListView.builder(
      itemCount: sortedSchedules.length,
      itemBuilder: (context, index) {
        final schedule = sortedSchedules[index];
        return TeamScheduleCard(schedule: schedule);
      },
    );
  }
}
