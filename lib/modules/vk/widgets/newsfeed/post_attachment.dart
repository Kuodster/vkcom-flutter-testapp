import 'package:flutter/material.dart';
import 'package:syazanou/modules/vk/models/vk_attachment.dart';
import 'package:syazanou/modules/vk/widgets/vk_image_display.dart';

part 'post_attachment_photo.dart';

part 'post_attachment_doc.dart';

part 'post_attachment_video.dart';

class PostAttachment extends StatelessWidget {
  final VkAttachment attachment;

  const PostAttachment({
    Key? key,
    required this.attachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (attachment.type) {
      case attachmentPhoto:
        return PostAttachmentPhoto(photo: attachment.photo!);
      case attachmentDoc:
        return PostAttachmentDoc(doc: attachment.doc!);
      case attachmentVideo:
        return PostAttachmentVideo(video: attachment.video!);
      default:
        return const SizedBox();
    }
  }
}
