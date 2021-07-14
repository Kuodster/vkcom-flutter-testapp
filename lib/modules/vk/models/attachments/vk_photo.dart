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

  VkPhotoSize get previewSize =>
      sizes.firstWhere((element) => element.type == 'r');
}

class VkPhotoSize {
  final String url;
  final int width;
  final int height;
  final String type;

  VkPhotoSize({
    required this.url,
    required this.width,
    required this.height,
    required this.type,
  });

  factory VkPhotoSize.fromJson(dynamic json) {
    return VkPhotoSize(
      url: json['url'] ?? json['src'],
      width: json['width'],
      height: json['height'],
      type: json['type'],
    );
  }
}
