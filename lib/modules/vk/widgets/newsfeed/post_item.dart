import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:collection/collection.dart';
import 'package:syazanou/modules/vk/models/vk_attachment.dart';
import 'package:syazanou/modules/vk/models/vk_group.dart';
import 'package:syazanou/modules/vk/models/vk_newsfeed_item.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';
import 'package:syazanou/modules/vk/widgets/newsfeed/like_button.dart';
import 'package:syazanou/modules/vk/widgets/newsfeed/post_attachment.dart';
import 'package:syazanou/modules/vk/widgets/newsfeed/stat_counter.dart';
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
    final baseTextStyle = Theme.of(context).textTheme.bodyText2!;

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
                  child: LikeButton(
                    liked: userLikes,
                    count: newsfeedItem.likes?.count ?? 0,
                  ) /*_StatCounter(
                    count: newsfeedItem.likes?.count ?? 0,
                    icon: FaIcon(
                      userLikes
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: userLikes
                          ? Colors.orange
                          : baseTextStyle.color!.withOpacity(0.7),
                    ),
                  )*/
                  ,
                ),
              ),
              const Spacer(),
              StatCounter(
                count: newsfeedItem.comments?.count ?? 0,
                icon: FaIcon(
                  FontAwesomeIcons.comments,
                  color: baseTextStyle.color!.withOpacity(0.7),
                ),
              ),
              StatCounter(
                count: newsfeedItem.reposts?.count ?? 0,
                icon: FaIcon(
                  FontAwesomeIcons.share,
                  color: baseTextStyle.color!.withOpacity(0.7),
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

    final baseTextStyle = Theme.of(context).textTheme.bodyText2!;

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
                    style: baseTextStyle,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    intl.DateFormat('d MMM, HH:mm', 'en').format(
                      DateTime.fromMillisecondsSinceEpoch(item.date * 1000),
                    ),
                    style: baseTextStyle.copyWith(
                      color: baseTextStyle.color!.withOpacity(0.54),
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
        if (firstAttachment != null) ...[
          const SizedBox(height: 10.0),
          Center(
            child: PostAttachment(
              attachment: firstAttachment,
            ),
          ),
        ],
      ],
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
    final style = Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 13.0,
          height: 1.2,
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
