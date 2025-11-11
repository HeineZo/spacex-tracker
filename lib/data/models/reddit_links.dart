class RedditLinks {
  final String? campaign;
  final String? launch;
  final String? media;
  final String? recovery;

  RedditLinks({
    this.campaign,
    this.launch,
    this.media,
    this.recovery,
  });

  factory RedditLinks.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RedditLinks();
    return RedditLinks(
      campaign: json['campaign'] as String?,
      launch: json['launch'] as String?,
      media: json['media'] as String?,
      recovery: json['recovery'] as String?,
    );
  }
}

