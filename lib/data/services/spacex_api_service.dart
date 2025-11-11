import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../../data/models/launch.dart';

class SpaceXApiService {
  static const String _baseUrl = 'https://api.spacexdata.com/v5';

  final http.Client _client;

  SpaceXApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Launch> fetchNextLaunch() async {
    final uri = Uri.parse('$_baseUrl/launches/next');
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Erreur lors du chargement du prochain lancement (${response.statusCode})');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return Launch.fromJson(data);
  }

  Future<List<Launch>> fetchLatestLaunches({int limit = 100}) async {
    final uri = Uri.parse('$_baseUrl/launches/past');
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Erreur lors du chargement des lancements (${response.statusCode})');
    }
    final data = json.decode(response.body) as List<dynamic>;
    final launches = data
        .map((e) => Launch.fromJson(e as Map<String, dynamic>))
        .toList();
    return launches.sublist(0, math.min(limit, launches.length));
  }

  Future<Launch> fetchLaunchById(String id) async {
    final uri = Uri.parse('$_baseUrl/launches/$id');
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Erreur lors du chargement du lancement (${response.statusCode})');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return Launch.fromJson(data);
  }

  Future<List<Launch>> fetchLaunchesByIds(List<String> ids) async {
    final futures = ids.map((id) => fetchLaunchById(id));
    return await Future.wait(futures);
  }

  void dispose() {
    _client.close();
  }
}


