import 'package:collection/collection.dart';

part 'attachments/vk_photo.dart';

part 'attachments/vk_doc.dart';

const attachmentPhoto = 'photo';
const attachmentUnknown = 'unknown';
const attachmentDoc = 'doc';

class VkAttachment {
  final String type;

  final VkPhoto? photo;
  final VkDoc? doc;

  VkAttachment({
    required this.type,
    this.photo,
    this.doc,
  });

  factory VkAttachment.fromJson(dynamic json) {
    return VkAttachment(
      type: json['type'],
      photo: json['photo'] != null ? VkPhoto.fromJson(json['photo']) : null,
      doc: json['doc'] != null ? VkDoc.fromJson(json['doc']) : null,
    );
  }

  String attachmentType() {
    switch (type) {
      case 'photo':
        return attachmentPhoto;
      case 'doc':
        return attachmentDoc;
      default:
        return attachmentUnknown;
    }
  }
}
