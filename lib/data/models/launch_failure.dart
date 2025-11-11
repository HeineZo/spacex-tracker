class LaunchFailure {
  final int time;
  final int? altitude;
  final String reason;

  LaunchFailure({required this.time, this.altitude, required this.reason});

  factory LaunchFailure.fromJson(Map<String, dynamic> json) {
    return LaunchFailure(
      time: (json['time'] ?? 0) as int,
      altitude: json['altitude'] as int?,
      reason: (json['reason'] ?? '') as String,
    );
  }
}


