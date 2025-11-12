import 'package:waiver_wire_wonderland/models/game_stat.dart';

class Player {
  final String id;
  final int playerId; // Added for linking with fantasy data
  final String name;
  final List<String> position;
  final String team;
  final String imageUrl;

  // Season Averages (for 9-cat)
  final double avgPoints;
  final double avgRebounds;
  final double avgAssists;
  final double avgSteals;
  final double avgBlocks;
  final double avgTurnovers;
  final double avgFieldGoalPercentage;
  final double avgFreeThrowPercentage;
  final double avgThreePointersMade;

  final List<GameStat> gameLog;

  const Player({
    required this.id,
    required this.playerId,
    required this.name,
    required this.position,
    required this.team,
    this.imageUrl = '',
    this.avgPoints = 0.0,
    this.avgRebounds = 0.0,
    this.avgAssists = 0.0,
    this.avgSteals = 0.0,
    this.avgBlocks = 0.0,
    this.avgTurnovers = 0.0,
    this.avgFieldGoalPercentage = 0.0,
    this.avgFreeThrowPercentage = 0.0,
    this.avgThreePointersMade = 0.0,
    this.gameLog = const [],
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    var gameLogFromJson = json['gameLog'] as List;
    List<GameStat> gameLogList = gameLogFromJson.map((i) => GameStat.fromJson(i)).toList();

    return Player(
      id: json['id'],
      playerId: json['playerId'] ?? 0, // Add playerId parsing
      name: json['name'],
      position: List<String>.from(json['position']),
      team: json['team'],
      imageUrl: json['imageUrl'] ?? '',
      avgPoints: (json['avgPoints'] as num).toDouble(),
      avgRebounds: (json['avgRebounds'] as num).toDouble(),
      avgAssists: (json['avgAssists'] as num).toDouble(),
      avgSteals: (json['avgSteals'] as num).toDouble(),
      avgBlocks: (json['avgBlocks'] as num).toDouble(),
      avgTurnovers: (json['avgTurnovers'] as num).toDouble(),
      avgFieldGoalPercentage: (json['avgFieldGoalPercentage'] as num).toDouble(),
      avgFreeThrowPercentage: (json['avgFreeThrowPercentage'] as num).toDouble(),
      avgThreePointersMade: (json['avgThreePointersMade'] as num).toDouble(),
      gameLog: gameLogList,
    );
  }
}
