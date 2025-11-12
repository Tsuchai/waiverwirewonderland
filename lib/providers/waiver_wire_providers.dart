import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:waiver_wire_wonderland/models/player.dart';
import 'package:waiver_wire_wonderland/models/team_schedule.dart';

part 'waiver_wire_providers.g.dart';

@Riverpod(keepAlive: true)
class AllPlayers extends _$AllPlayers {
  @override
  Future<List<Player>> build() async {
    // This method now automatically loads and parses the player data at startup.
    final String jsonString = await rootBundle.loadString('assets/players_data.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Player.fromJson(json)).toList();
  }
}

@riverpod
class TeamSchedules extends _$TeamSchedules {
  @override
  List<TeamSchedule> build() {
    // This is a simple, read-only provider.
    return [
      TeamSchedule(teamName: 'Los Angeles Lakers', gamesThisWeek: 4, teamLogoUrl: ''),
      TeamSchedule(teamName: 'Boston Celtics', gamesThisWeek: 4, teamLogoUrl: ''),
      TeamSchedule(teamName: 'Denver Nuggets', gamesThisWeek: 3, teamLogoUrl: ''),
      TeamSchedule(teamName: 'Golden State Warriors', gamesThisWeek: 2, teamLogoUrl: ''),
      TeamSchedule(teamName: 'Phoenix Suns', gamesThisWeek: 2, teamLogoUrl: ''),
    ];
  }
}
