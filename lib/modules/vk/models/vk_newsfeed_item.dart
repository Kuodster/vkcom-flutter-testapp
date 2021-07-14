import 'package:syazanou/modules/vk/models/vk_attachment.dart';

enum SourceType { person, group }

class VkNewsfeedItem {
  final String type;
  final int sourceId;
  final int date;
  final int postId;
  final String? postType;
  final String? text;
  final int? ownerId;
  final List<VkNewsfeedItem>? copyHistory;

  final VkNewsfeedItemComments? comments;
  final VkNewsfeedItemReposts? reposts;
  VkNewsfeedItemLikes? likes;

  final List<VkAttachment> attachments;

  VkNewsfeedItem({
    required this.type,
    required this.sourceId,
    required this.date,
    required this.postId,
    this.comments,
    this.likes,
    this.reposts,
    this.postType,
    this.text,
    this.attachments = const <VkAttachment>[],
    this.copyHistory,
    this.ownerId,
  });

  factory VkNewsfeedItem.fromJson(
    dynamic json,
  ) {
    final attachments = <VkAttachment>[];
    if (json['attachments'] != null) {
      for (final attachment in json['attachments']) {
        attachments.add(VkAttachment.fromJson(attachment));
      }
    }
    return VkNewsfeedItem(
      type: json['type'] ?? 'unknown',
      sourceId: json['source_id'] ?? 0,
      date: json['date'],
      postId: json['post_id'] ?? 0,
      postType: json['post_type'],
      text: json['text'],
      comments: json['comments'] != null
          ? VkNewsfeedItemComments.fromJson(json['comments'])
          : null,
      likes: json['likes'] != null
          ? VkNewsfeedItemLikes.fromJson(json['likes'])
          : null,
      reposts: json['reposts'] != null
          ? VkNewsfeedItemReposts.fromJson(json['reposts'])
          : null,
      attachments: attachments,
      copyHistory: json['copy_history'] != null
          ? [
              for (final ch in json['copy_history'])
                VkNewsfeedItem.fromJson(ch),
            ]
          : null,
      ownerId: json['owner_id'],
    );
  }

  SourceType get sourceType =>
      realOwnerId < 0 ? SourceType.group : SourceType.person;

  bool get isQuote => copyHistory != null && copyHistory!.isNotEmpty;

  int get realOwnerId => ownerId ?? sourceId;
}

class VkNewsfeedItemComments {
  final int count;

  VkNewsfeedItemComments({
    required this.count,
  });

  factory VkNewsfeedItemComments.fromJson(dynamic json) {
    return VkNewsfeedItemComments(count: json['count']);
  }
}

class VkNewsfeedItemReposts {
  final int count;

  VkNewsfeedItemReposts({
    required this.count,
  });

  factory VkNewsfeedItemReposts.fromJson(dynamic json) {
    return VkNewsfeedItemReposts(count: json['count']);
  }
}

class VkNewsfeedItemLikes {
  final int count;
  bool userLikes;
  final bool canLike;

  VkNewsfeedItemLikes({
    required this.count,
    required this.userLikes,
    required this.canLike,
  });

  factory VkNewsfeedItemLikes.fromJson(dynamic json) {
    return VkNewsfeedItemLikes(
      count: json['count'],
      userLikes: json['user_likes'] == 1,
      canLike: json['can_like'] == 1,
    );
  }
}
