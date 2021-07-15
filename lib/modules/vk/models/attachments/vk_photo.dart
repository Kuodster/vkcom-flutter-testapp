part of '../vk_attachment.dart';

class VkPhoto {
  final int id;
  final String? text;
  final List<VkPhotoSize> sizes;

  VkPhoto({
    required this.id,
    this.sizes = const <VkPhotoSize>[],
    this.text,
  });

  factory VkPhoto.fromJson(dynamic json) {
    final sizes = <VkPhotoSize>[];
    if (json['sizes'] != null) {
      for (final size in json['sizes']) {
        sizes.add(VkPhotoSize.fromJson(size));
      }
    }
    return VkPhoto(
      id: json['id'],
      sizes: sizes,
    );
  }

  VkPhotoSize get previewImage =>
      sizes.firstWhere((element) => element.type == 'r');
}

class VkPhotoSize extends VkBaseImage {
  final String type;

  VkPhotoSize({
    required this.type,
    url,
    width,
    height,
  }) : super(
          url: url,
          width: width,
          height: height,
        );

  factory VkPhotoSize.fromJson(dynamic json) {
    return VkPhotoSize(
      url: json['url'] ?? json['src'],
      width: json['width'],
      height: json['height'],
      type: json['type'],
    );
  }
}
