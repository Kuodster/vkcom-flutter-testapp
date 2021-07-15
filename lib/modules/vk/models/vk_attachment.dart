import 'package:collection/collection.dart';
import 'package:syazanou/modules/app/logging/log.dart';

part 'attachments/vk_photo.dart';

part 'attachments/vk_doc.dart';

part 'attachments/vk_video.dart';

part 'attachments/vk_base_image.dart';

const attachmentUnknown = 'unknown';
const attachmentPhoto = 'photo';
const attachmentDoc = 'doc';
const attachmentVideo = 'video';

class VkAttachment {
  final String type;

  final VkPhoto? photo;
  final VkDoc? doc;
  final VkVideo? video;

  VkAttachment({
    required this.type,
    this.photo,
    this.doc,
    this.video,
  });

  factory VkAttachment.fromJson(dynamic json) {
    return VkAttachment(
      type: json['type'],
      photo: json['photo'] != null ? VkPhoto.fromJson(json['photo']) : null,
      doc: json['doc'] != null ? VkDoc.fromJson(json['doc']) : null,
      video: json['video'] != null ? VkVideo.fromJson(json['video']) : null,
    );
  }

  String attachmentType() {
    switch (type) {
      case 'photo':
        return attachmentPhoto;
      case 'doc':
        return attachmentDoc;
      case 'video':
        return attachmentVideo;
      default:
        return attachmentUnknown;
    }
  }
}
