import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syazanou/modules/vk/models/vk_attachment.dart';

class VkImageDisplay extends StatelessWidget {
  final VkBaseImage vkImage;

  final Widget? overlay;

  const VkImageDisplay({
    Key? key,
    required this.vkImage,
    this.overlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = _buildPlaceholder(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: vkImage.width / vkImage.height,
          child: CachedNetworkImage(
            imageUrl: vkImage.url,
            progressIndicatorBuilder: (_, __, ___) => placeholder,
          ),
        ),
        if (overlay != null) overlay!,
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final child = Container(
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.white12 : Colors.black26,
      ),
    );

    return Shimmer.fromColors(
      baseColor: isDarkTheme ? Colors.white24 : Colors.black38,
      highlightColor: isDarkTheme ? Colors.white54 : Colors.black54,
      child: child,
    );
  }
}
