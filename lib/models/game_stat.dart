import 'package:intl/intl.dart';

class GameStat {
  final DateTime gameDate;
  final String matchup;
  final String wl; // Win/Loss
  final int points;
  final int rebounds;
  final int assists;
  final int steals;
  final int blocks;
  final int turnovers;
  final double fgPct;
  final double ftPct;
  final int threePointersMade;

  const GameStat({
    required this.gameDate,
    required this.matchup,
    required this.wl,
    required this.points,
    required this.rebounds,
    required this.assists,
    required this.steals,
    required this.blocks,
    required this.turnovers,
    required this.fgPct,
    required this.ftPct,
    required this.threePointersMade,
  });

  factory GameStat.fromJson(Map<String, dynamic> json) {
    // Helper to parse date format like "Nov 11, 2025"
    DateTime parseDate(String dateStr) {
      try {
        return DateFormat('MMM dd, yyyy').parse(dateStr);
      } catch (e) {
        return DateTime.now(); // Fallback
      }
    }

    return GameStat(
      gameDate: parseDate(json['gameDate']),
      matchup: json['matchup'],
      wl: json['wl'] ?? '',
      points: json['pts'] ?? 0,
      rebounds: json['reb'] ?? 0,
      assists: json['ast'] ?? 0,
      steals: json['stl'] ?? 0,
      blocks: json['blk'] ?? 0,
      turnovers: json['tov'] ?? 0,
      fgPct: (json['fg_pct'] as num?)?.toDouble() ?? 0.0,
      ftPct: (json['ft_pct'] as num?)?.toDouble() ?? 0.0,
      threePointersMade: json['fg3m'] ?? 0,
    );
  }
}
