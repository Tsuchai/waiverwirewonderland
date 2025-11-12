import 'package:flutter/material.dart';
import 'package:waiver_wire_wonderland/models/team_schedule.dart';

class TeamScheduleCard extends StatelessWidget {
  final TeamSchedule schedule;

  const TeamScheduleCard({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          // In a real app, you'd use an Image.network(schedule.teamLogoUrl)
          child: Text(schedule.gamesThisWeek.toString()),
        ),
        title: Text(schedule.teamName),
        subtitle: Text('${schedule.gamesThisWeek} games this week'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle navigating to a list of players for this team
        },
      ),
    );
  }
}
