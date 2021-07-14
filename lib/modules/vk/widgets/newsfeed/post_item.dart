import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:collection/collection.dart';
import 'package:syazanou/modules/vk/models/vk_attachment.dart';
import 'package:syazanou/modules/vk/models/vk_group.dart';
import 'package:syazanou/modules/vk/models/vk_newsfeed_item.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';
import 'package:syazanou/modules/vk/widgets/sized_photo.dart';
import 'package:url_launcher/url_launcher.dart';

const textMaxLengthBeforeCollapse = 200;

class PostItem extends StatelessWidget {
  final VkNewsfeedItem newsfeedItem;
  final Map<int, VkGroup>? groups;
  final Map<int, VkUser>? profiles;

  final Function(bool isDelete)? onLike;

  const PostItem({
    Key? key,
    required this.newsfeedItem,
    this.groups,
    this.profiles,
    this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userLikes = newsfeedItem.likes?.userLikes == true;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostPreview(
            item: newsfeedItem,
            groups: groups,
            profiles: profiles,
          ),
          if (newsfeedItem.isQuote)
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(0.05),
              ),
              child: _PostPreview(
                item: newsfeedItem.copyHistory!.first,
                groups: groups,
                profiles: profiles,
              ),
            ),
          const SizedBox(height: 10.0),
          const Divider(
            height: 0,
            color: Colors.white24,
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5.0),
                  onTap: () => onLike?.call(userLikes),
                  child: _StatCounter(
                    count: newsfeedItem.likes?.count ?? 0,
                    icon: FaIcon(
                      userLikes
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: userLikes ? Colors.orange : Colors.white70,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              _StatCounter(
                count: newsfeedItem.comments?.count ?? 0,
                icon: const FaIcon(
                  FontAwesomeIcons.comments,
                  color: Colors.white70,
                ),
              ),
              _StatCounter(
                count: newsfeedItem.reposts?.count ?? 0,
                icon: const FaIcon(
                  FontAwesomeIcons.share,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostPreview extends StatelessWidget {
  final VkNewsfeedItem item;

  final Map<int, VkGroup>? groups;
  final Map<int, VkUser>? profiles;

  const _PostPreview({
    Key? key,
    required this.item,
    this.groups,
    this.profiles,
  }) : super(key: key);

  T? _findEntryInMap<T>(Map<int, T> provider) {
    final key = item.realOwnerId.abs();
    if (provider.containsKey(key)) {
      return provider[key];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    VkUser? user;
    VkGroup? group;

    if (item.sourceType == SourceType.person && profiles != null) {
      user = _findEntryInMap(profiles!);
    } else if (groups != null) {
      group = _findEntryInMap(groups!);
    }

    String? photoUrl = group?.photo100 ?? user?.photo100;
    String? screenName = group?.name ?? user?.displayName;

    final VkAttachment? firstAttachment = item.attachments.firstOrNull;
    String? imageUrl;
    VkPhotoSize? photoSize;

    if (firstAttachment != null) {
      switch (firstAttachment.type) {
        case attachmentPhoto:
          final photo = firstAttachment.photo;
          photoSize = photo?.previewSize;
          break;
        case attachmentDoc:
          final doc = firstAttachment.doc;
          if (doc?.isImage == true) {
            photoSize = doc!.previewSize;
            imageUrl = doc.url;
          }
          break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey[800],
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    screenName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    intl.DateFormat('d MMM в HH:mm', 'ru').format(
                      DateTime.fromMillisecondsSinceEpoch(item.date * 1000),
                    ),
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (item.text?.isNotEmpty == true) ...[
          const SizedBox(height: 20.0),
          _ItemText(
            text: item.text!,
          ),
        ],
        if (photoSize != null) ...[
          const SizedBox(height: 10.0),
          Center(
            child: SizedPhoto(
              src: imageUrl,
              photoSize: photoSize,
            ),
          ),
        ],
      ],
    );
  }
}

class _StatCounter extends StatelessWidget {
  final Widget? icon;
  final int count;

  const _StatCounter({
    Key? key,
    required this.count,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 10.0),
            Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ],
      ),
    );
  }
}

class _ItemText extends StatefulWidget {
  final String text;

  const _ItemText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  __ItemTextState createState() => __ItemTextState();
}

class __ItemTextState extends State<_ItemText> {
  String get text => widget.text;

  bool _expanded = false;

  bool isOverflowed(
    String text,
    TextStyle style, {
    double minWidth = 0,
    double maxWidth = double.infinity,
    int maxLines = 4,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  void _expand() {
    if (!_expanded) {
      setState(() {
        _expanded = true;
      });
    }
  }

  Future<void> _onLinkClicked(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: Colors.white.withOpacity(0.9),
    );
    return GestureDetector(
      onTap: _expand,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Linkify(
            text: text,
            style: style,
            maxLines: _expanded ? null : 5,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            onOpen: _onLinkClicked,
          ),
          if (!_expanded && isOverflowed(text, style)) ...[
            const SizedBox(height: 10.0),
            Text(
              'Показать полностью',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
