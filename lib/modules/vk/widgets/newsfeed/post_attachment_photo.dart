part of 'post_attachment.dart';

class PostAttachmentPhoto extends StatelessWidget {
  final VkPhoto photo;

  const PostAttachmentPhoto({
    Key? key,
    required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VkPhotoSize? photoSize = photo.previewImage;

    return photoSize != null
        ? VkImageDisplay(vkImage: photoSize)
        : const SizedBox();
  }
}
