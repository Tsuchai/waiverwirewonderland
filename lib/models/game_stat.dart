// lib/models/game_stat.dart
class GameStat {
  final DateTime date;
  final String opponent;
  final double minutes;
  final int points;
  final int rebounds;
  final int assists;
  final int steals;
  final int blocks;
  final int turnovers;
  final int fieldGoalsMade;
  final int fieldGoalsAttempted;
  final int threePointersMade;
  final int threePointersAttempted;
  final int freeThrowsMade;
  final int freeThrowsAttempted;

  const GameStat({
    required this.date,
    required this.opponent,
    required this.minutes,
    required this.points,
    required this.rebounds,
    required this.assists,
    required this.steals,
    required this.blocks,
    this.turnovers = 0,
    this.fieldGoalsMade = 0,
    this.fieldGoalsAttempted = 0,
    this.threePointersMade = 0,
    this.threePointersAttempted = 0,
    this.freeThrowsMade = 0,
    this.freeThrowsAttempted = 0,
  });

  // Helper getters for percentages
  double get fieldGoalPercentage => fieldGoalsAttempted > 0 ? fieldGoalsMade / fieldGoalsAttempted : 0.0;
  double get threePointPercentage => threePointersAttempted > 0 ? threePointersMade / threePointersAttempted : 0.0;
  double get freeThrowPercentage => freeThrowsAttempted > 0 ? freeThrowsMade / freeThrowsAttempted : 0.0;

  factory GameStat.fromJson(Map<String, dynamic> json) {
    return GameStat(
      date: DateTime.parse(json['date']),
      opponent: json['opponent'],
      minutes: (json['minutes'] as num).toDouble(),
      points: json['points'],
      rebounds: json['rebounds'],
      assists: json['assists'],
      steals: json['steals'],
      blocks: json['blocks'],
      turnovers: json['turnovers'] ?? 0,
      fieldGoalsMade: json['fieldGoalsMade'] ?? 0,
      fieldGoalsAttempted: json['fieldGoalsAttempted'] ?? 0,
      threePointersMade: json['threePointersMade'] ?? 0,
      threePointersAttempted: json['threePointersAttempted'] ?? 0,
      freeThrowsMade: json['freeThrowsMade'] ?? 0,
      freeThrowsAttempted: json['freeThrowsAttempted'] ?? 0,
    );
  }
}
