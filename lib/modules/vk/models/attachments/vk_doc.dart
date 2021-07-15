part of '../vk_attachment.dart';

class VkDoc {
  final int id;
  final String ext;
  final String url;
  final VkDocPreview? preview;

  VkDoc({
    required this.id,
    required this.ext,
    required this.url,
    this.preview,
  });

  factory VkDoc.fromJson(dynamic json) {
    return VkDoc(
      id: json['id'],
      ext: json['ext'],
      url: json['url'],
      preview: json['preview'] != null
          ? VkDocPreview.fromJson(json['preview'])
          : null,
    );
  }

  bool get isImage => ext == 'gif';

  VkPhotoSize? get previewImage =>
      preview?.photo?.sizes.firstWhereOrNull((element) => element.type == 'o');
}

class VkDocPreview {
  final VkDocPreviewSizes? photo;

  VkDocPreview({
    required this.photo,
  });

  factory VkDocPreview.fromJson(dynamic json) {
    return VkDocPreview(
      photo: json['photo'] != null
          ? VkDocPreviewSizes.fromJson(json['photo'])
          : null,
    );
  }
}

class VkDocPreviewSizes {
  final List<VkPhotoSize> sizes;

  VkDocPreviewSizes({
    required this.sizes,
  });

  factory VkDocPreviewSizes.fromJson(dynamic json) {
    final sizes = <VkPhotoSize>[];
    if (json['sizes'] != null) {
      for (final size in json['sizes']) {
        sizes.add(VkPhotoSize.fromJson(size));
      }
    }
    return VkDocPreviewSizes(sizes: sizes);
  }
}
