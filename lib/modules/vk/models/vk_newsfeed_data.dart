import 'package:syazanou/modules/vk/models/vk_group.dart';
import 'package:syazanou/modules/vk/models/vk_newsfeed_item.dart';

import 'vk_user.dart';

class VkNewsfeedData {
  final List<VkNewsfeedItem> items;
  final Map<int, VkUser> profiles;
  final Map<int, VkGroup> groups;
  final String? nextFrom;

  VkNewsfeedData({
    required this.items,
    required this.profiles,
    required this.groups,
    this.nextFrom,
  });

  factory VkNewsfeedData.fromJson(dynamic json) {
    final profiles = <int, VkUser>{};
    for (final entry in json['profiles']) {
      final profile = VkUser.fromJson(entry);
      if (!profiles.containsKey(profile.id)) {
        profiles[profile.id] = profile;
      }
    }

    final groups = <int, VkGroup>{};
    for (final entry in json['groups']) {
      final group = VkGroup.fromJson(entry);
      if (!groups.containsKey(group.id)) {
        groups[group.id] = group;
      }
    }

    final items = <VkNewsfeedItem>[
      for (final entry in json['items']) VkNewsfeedItem.fromJson(entry),
    ];

    return VkNewsfeedData(
      items: items,
      profiles: profiles,
      groups: groups,
      nextFrom: json['next_from'],
    );
  }

  static Map<int, T> mergeMaps<T>(
      Map<int, T> source, List<Map<int, T>> addons) {
    final copy = {...source};
    for (final addon in addons) {
      addon.forEach((key, value) {
        if (!copy.containsKey(key)) {
          copy[key] = value;
        }
      });
    }

    return copy;
  }

  VkNewsfeedData mergeWith(VkNewsfeedData feedData) {
    return VkNewsfeedData(
      items: items + feedData.items,
      groups: mergeMaps(groups, [feedData.groups]),
      profiles: mergeMaps(profiles, [feedData.profiles]),
    );
  }

  bool get isLastPage => nextFrom == null;
}
