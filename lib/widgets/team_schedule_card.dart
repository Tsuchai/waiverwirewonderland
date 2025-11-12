import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waiver_wire_wonderland/models/team_schedule.dart';
import 'package:waiver_wire_wonderland/screens/team_roster_screen.dart';

class TeamScheduleCard extends StatelessWidget {
  final TeamSchedule schedule;

  const TeamScheduleCard({
    super.key,
    required this.schedule,
  });

  // List to date convertor (DateFormat)
  String _getDaysString(List<DateTime> dates) {
    if (dates.isEmpty) {
      return 'No games';
    }
    return dates.map((date) => DateFormat.E().format(date).substring(0, 2)).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final gameCount = schedule.gamesThisWeek;
    final daysString = _getDaysString(schedule.gameDates);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          child: Text(
            gameCount.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(schedule.teamName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$gameCount games this week'),
            const SizedBox(height: 4),
            Text(
              daysString,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamRosterScreen(
                teamAbbrev: schedule.teamName,
                teamName: schedule.teamName,
              ),
            ),
          );
        },
      ),
    );
  }
}
