part of '../vk_attachment.dart';

class VkVideo {
  final String accessKey;
  final int? width;
  final int? height;
  final String? title;
  final String? description;

  final List<VkVideoImage> image;

  VkVideo({
    required this.accessKey,
    this.width,
    this.height,
    this.image = const <VkVideoImage>[],
    this.title,
    this.description,
  });

  factory VkVideo.fromJson(dynamic json) {
    final image = <VkVideoImage>[];
    if (json['image'] != null) {
      for (final img in json['image']) {
        image.add(VkVideoImage.fromJson(img));
      }
    }
    return VkVideo(
      accessKey: json['access_key'],
      width: json['width'],
      height: json['height'],
      image: image,
      title: json['title'],
      description: json['description'],
    );
  }

  VkVideoImage? get previewImage =>
      image.firstWhereOrNull((element) => element.url.contains('vid_x'));
}

class VkVideoImage extends VkBaseImage {
  final bool withPadding;

  VkVideoImage({
    url,
    width,
    height,
    required this.withPadding,
  }) : super(
          url: url,
          width: width,
          height: height,
        );

  factory VkVideoImage.fromJson(dynamic json) => VkVideoImage(
        withPadding: json['with_padding'] == 1,
        width: json['width'],
        height: json['height'],
        url: json['url'],
      );
}
