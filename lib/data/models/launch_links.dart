import 'launch_patch.dart';
import 'reddit_links.dart';
import 'flickr_links.dart';

class LaunchLinks {
  final LaunchPatch patch;
  final String? article;
  final String? webcast;
  final String? wikipedia;
  final RedditLinks? reddit;
  final FlickrLinks? flickr;
  final String? presskit;
  final String? youtubeId;

  LaunchLinks({
    required this.patch,
    this.article,
    this.webcast,
    this.wikipedia,
    this.reddit,
    this.flickr,
    this.presskit,
    this.youtubeId,
  });

  factory LaunchLinks.fromJson(Map<String, dynamic>? json) {
    final links = json ?? const <String, dynamic>{};
    return LaunchLinks(
      patch: LaunchPatch.fromJson(links['patch'] as Map<String, dynamic>?),
      article: links['article'] as String?,
      webcast: links['webcast'] as String?,
      wikipedia: links['wikipedia'] as String?,
      reddit: RedditLinks.fromJson(links['reddit'] as Map<String, dynamic>?),
      flickr: FlickrLinks.fromJson(links['flickr'] as Map<String, dynamic>?),
      presskit: links['presskit'] as String?,
      youtubeId: links['youtube_id'] as String?,
    );
  }
}


