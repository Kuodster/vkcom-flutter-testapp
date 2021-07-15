import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syazanou/modules/vk/models/vk_attachment.dart';

class SizedPhoto extends StatelessWidget {
  final VkPhotoSize photoSize;
  final String? src;

  const SizedPhoto({
    Key? key,
    required this.photoSize,
    this.src,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = src ?? photoSize.url;
    final placeholder = _buildPlaceholder(context);
    late final Widget child;

    if (src == null) {
      child = CachedNetworkImage(
        imageUrl: url,
        progressIndicatorBuilder: (_, __, ___) => placeholder,
      );
    } else {
      child = Stack(
        fit: StackFit.expand,
        children: [
          placeholder,
          const Center(
            child: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: Text('GIF'),
            ),
          ),
        ],
      );
    }

    return AspectRatio(
      aspectRatio: photoSize.width / photoSize.height,
      child: child,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final child = Container(
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.white12 : Colors.black26,
        image: src != null
            ? DecorationImage(
                image: NetworkImage(photoSize.url),
              )
            : null,
      ),
    );

    if (src != null) return child;

    return Shimmer.fromColors(
      baseColor: isDarkTheme ? Colors.white24 : Colors.black38,
      highlightColor: isDarkTheme ? Colors.white54 : Colors.black54,
      child: child,
    );
  }
}
