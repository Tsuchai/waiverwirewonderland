import 'package:waiver_wire_wonderland/models/fantasy_player.dart';

class FantasyTeam {
  final String teamName;
  final String owner;
  final List<FantasyPlayer> players;

  FantasyTeam({
    required this.teamName,
    required this.owner,
    required this.players,
  });

  factory FantasyTeam.fromJson(Map<String, dynamic> json) {
    var playersFromJson = json['players'] as List;
    List<FantasyPlayer> playerList = playersFromJson.map((i) => FantasyPlayer.fromJson(i)).toList();

    return FantasyTeam(
      teamName: json['team_name'],
      owner: json['owner'],
      players: playerList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'owner': owner,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}
