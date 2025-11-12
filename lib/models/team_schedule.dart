import 'package:intl/intl.dart'; // Import for DateFormat if needed for other parsing, though DateTime.parse handles ISO 8601

class TeamSchedule {
  final String teamName;
  final List<DateTime> gameDates;
  final String teamLogoUrl;

  TeamSchedule({
    required this.teamName,
    required this.gameDates,
    required this.teamLogoUrl,
  });

  // Helper to get the number of games
  int get gamesThisWeek => gameDates.length;

  factory TeamSchedule.fromJson(Map<String, dynamic> json) {
    final List<dynamic> datesJson = json['gameDates'] as List;
    final List<DateTime> parsedGameDates = datesJson
        .map((dateStr) => DateTime.parse(dateStr as String))
        .toList();

    return TeamSchedule(
      teamName: json['teamName'],
      gameDates: parsedGameDates,
      teamLogoUrl: json['teamLogoUrl'] ?? '', // Handle potential null or missing
    );
  }
}
