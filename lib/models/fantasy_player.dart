class FantasyPlayer {
  final String name;
  final int playerId;
  final String position;

  FantasyPlayer({
    required this.name,
    required this.playerId,
    required this.position,
  });

  factory FantasyPlayer.fromJson(Map<String, dynamic> json) {
    return FantasyPlayer(
      name: json['name'],
      playerId: json['playerId'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'playerId': playerId,
      'position': position,
    };
  }
}
