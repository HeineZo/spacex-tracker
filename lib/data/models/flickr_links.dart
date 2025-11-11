class FlickrLinks {
  final List<String> small;
  final List<String> original;

  FlickrLinks({
    required this.small,
    required this.original,
  });

  factory FlickrLinks.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FlickrLinks(small: const [], original: const []);
    return FlickrLinks(
      small: ((json['small'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      original: ((json['original'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

