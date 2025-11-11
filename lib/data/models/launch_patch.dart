class LaunchPatch {
  final String? small;
  final String? large;

  LaunchPatch({this.small, this.large});

  factory LaunchPatch.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LaunchPatch();
    return LaunchPatch(
      small: json['small'] as String?,
      large: json['large'] as String?,
    );
  }
}


