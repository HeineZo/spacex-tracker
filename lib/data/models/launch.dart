import 'dart:convert';
import 'launch_failure.dart';
import 'launch_links.dart';
import 'launch_core.dart';

class Launch {
  final String id;
  final String name;
  final String? details;
  final DateTime dateUtc;
  final bool? success;
  final List<LaunchFailure> failures;
  final String? rocketId;
  final LaunchLinks links;
  final int? flightNumber;
  final DateTime? dateLocal;
  final int? dateUnix;
  final String? datePrecision;
  final bool? upcoming;
  final List<LaunchCore> cores;
  final String? staticFireDateUtc;
  final int? staticFireDateUnix;
  final bool? tdb;
  final bool? net;
  final int? window;
  final List<String> crew;
  final List<String> ships;
  final List<String> capsules;
  final List<String> payloads;
  final String? launchpad;
  final bool? autoUpdate;

  Launch({
    required this.id,
    required this.name,
    required this.details,
    required this.dateUtc,
    required this.success,
    required this.failures,
    required this.rocketId,
    required this.links,
    this.flightNumber,
    this.dateLocal,
    this.dateUnix,
    this.datePrecision,
    this.upcoming,
    required this.cores,
    this.staticFireDateUtc,
    this.staticFireDateUnix,
    this.tdb,
    this.net,
    this.window,
    required this.crew,
    required this.ships,
    required this.capsules,
    required this.payloads,
    this.launchpad,
    this.autoUpdate,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return null;
      }
    }

    return Launch(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      details: json['details'] as String?,
      dateUtc: DateTime.parse((json['date_utc'] ?? json['dateUtc']) as String),
      success: json['success'] as bool?,
      failures: ((json['failures'] as List?) ?? const [])
          .map((e) => LaunchFailure.fromJson(e as Map<String, dynamic>))
          .toList(),
      rocketId: json['rocket'] as String?,
      links: LaunchLinks.fromJson(json['links'] as Map<String, dynamic>?),
      flightNumber: json['flight_number'] as int?,
      dateLocal: parseDate(json['date_local'] as String?),
      dateUnix: json['date_unix'] as int?,
      datePrecision: json['date_precision'] as String?,
      upcoming: json['upcoming'] as bool?,
      cores: ((json['cores'] as List?) ?? const [])
          .map((e) => LaunchCore.fromJson(e as Map<String, dynamic>?))
          .toList(),
      staticFireDateUtc: json['static_fire_date_utc'] as String?,
      staticFireDateUnix: json['static_fire_date_unix'] as int?,
      tdb: json['tdb'] as bool?,
      net: json['net'] as bool?,
      window: json['window'] as int?,
      crew: ((json['crew'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      ships: ((json['ships'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      capsules: ((json['capsules'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      payloads: ((json['payloads'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      launchpad: json['launchpad'] as String?,
      autoUpdate: json['auto_update'] as bool?,
    );
  }

  static List<Launch> listFromJson(String body) {
    final data = json.decode(body) as List<dynamic>;
    return data.map((e) => Launch.fromJson(e as Map<String, dynamic>)).toList();
  }
}


