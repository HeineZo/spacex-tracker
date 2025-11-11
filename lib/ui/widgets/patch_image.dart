import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

String? webSafeUrl(String? url) {
  if (url == null) return null;
  if (!kIsWeb) return url;
  final cleaned = url.replaceFirst(RegExp(r'^https?://'), '');
  return 'https://images.weserv.nl/?url=$cleaned';
}

class PatchImage extends StatelessWidget {
  final String? url;
  final double aspectRatio;

  const PatchImage({super.key, required this.url, this.aspectRatio = 16 / 9});

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = webSafeUrl(url);
    if (resolvedUrl == null) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(color: Colors.grey.shade300),
      );
    }
    return CachedNetworkImage(
      imageUrl: resolvedUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (c, _) => AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(color: Colors.grey.shade200),
      ),
      errorWidget: (c, _, __) => AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(color: Colors.grey.shade300),
      ),
    );
  }
}

class PatchAvatar extends StatelessWidget {
  final String? url;

  const PatchAvatar({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = webSafeUrl(url);
    if (resolvedUrl == null) return const CircleAvatar(child: Icon(Icons.rocket_launch));
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(resolvedUrl),
      backgroundColor: Colors.transparent,
    );
  }
}


