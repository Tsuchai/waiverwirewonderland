import 'package:intl/intl.dart'; // ISO 8061

class TeamSchedule {
  final String teamName;
  final List<DateTime> gameDates;
  final String teamLogoUrl;

  TeamSchedule({
    required this.teamName,
    required this.gameDates,
    required this.teamLogoUrl,
  });


  int get gamesThisWeek => gameDates.length;

  factory TeamSchedule.fromJson(Map<String, dynamic> json) {
    final List<dynamic> datesJson = json['gameDates'] as List;
    final List<DateTime> parsedGameDates = datesJson
        .map((dateStr) => DateTime.parse(dateStr as String))
        .toList();

    return TeamSchedule(
      teamName: json['teamName'],
      gameDates: parsedGameDates,
      teamLogoUrl: json['teamLogoUrl'] ?? '',
    );
  }
}
