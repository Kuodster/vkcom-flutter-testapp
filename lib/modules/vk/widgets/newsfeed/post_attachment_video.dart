part of 'post_attachment.dart';

class PostAttachmentVideo extends StatelessWidget {
  final VkVideo video;

  const PostAttachmentVideo({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (video.previewImage == null) return const SizedBox();
    return VkImageDisplay(
      vkImage: video.previewImage!,
      overlay: const PhysicalModel(
        color: Colors.white,
        elevation: 2.0,
        shape: BoxShape.circle,
        child: CircleAvatar(
          radius: 35.0,
          backgroundColor: Colors.white,
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
