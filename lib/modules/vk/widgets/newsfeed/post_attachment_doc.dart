part of 'post_attachment.dart';

class PostAttachmentDoc extends StatelessWidget {
  final VkDoc doc;

  const PostAttachmentDoc({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!doc.isImage || doc.previewImage == null) return const SizedBox();
    return VkImageDisplay(
      vkImage: doc.previewImage!,
      overlay: PhysicalModel(
        color: Colors.white,
        elevation: 2.0,
        shape: BoxShape.circle,
        child: CircleAvatar(
          radius: 35.0,
          backgroundColor: Colors.white,
          child: Text(doc.ext.toUpperCase()),
        ),
      ),
    );
  }
}
