import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:waiver_wire_wonderland/models/fantasy_team.dart';
import 'package:waiver_wire_wonderland/models/player.dart';
import 'package:waiver_wire_wonderland/models/team_schedule.dart';

part 'waiver_wire_providers.g.dart';

@Riverpod(keepAlive: true)
class AllPlayers extends _$AllPlayers {
  @override
  Future<List<Player>> build() async {
    final String jsonString = await rootBundle.loadString('assets/players_data_enriched.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Player.fromJson(json)).toList();
  }
}

@Riverpod(keepAlive: true)
class FullSchedule extends _$FullSchedule {
  @override
  Future<Map<String, List<TeamSchedule>>> build() async {
    final String jsonString = await rootBundle.loadString('assets/nba_weekly_schedule.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final Map<String, List<TeamSchedule>> scheduleMap = {};
    jsonMap.forEach((week, teamsJson) {
      final teams = (teamsJson as List).map((teamJson) => TeamSchedule.fromJson(teamJson)).toList();
      scheduleMap[week] = teams;
    });
    return scheduleMap;
  }
}

@riverpod
class MyLeague extends _$MyLeague {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/my_league.json');
  }

  Future<void> _saveToFile(List<FantasyTeam> teams) async {
    final file = await _localFile;
    final jsonList = teams.map((team) => team.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  @override
  Future<List<FantasyTeam>> build() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        return jsonList.map((json) => FantasyTeam.fromJson(json)).toList();
      }
    } catch (e) {
      // If reading fails, just return an empty list and let it be fetched again.
    }
    return [];
  }

  Future<void> fetchLeague(String leagueId) async {
    state = const AsyncValue.loading();
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/get-league/$leagueId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          final List<dynamic> teamsJson = data['teams'];
          final teams = teamsJson.map((json) => FantasyTeam.fromJson(json)).toList();
          await _saveToFile(teams);
          state = AsyncValue.data(teams);
        } else {
          throw Exception('API Error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load league. Status code: ${response.statusCode}');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteLeague() async {
    state = const AsyncValue.loading();
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
      state = const AsyncValue.data([]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
