import 'package:syazanou/modules/vk/models/vk_user_info.dart';

class VkUser {
  int id;
  String firstName;
  String lastName;
  String? phone;
  String? screenName;

  String? photo100;

  VkUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.screenName,
    this.photo100,
  });

  factory VkUser.fromJson(Map<String, dynamic> json, [VkUserInfo? vkUserInfo]) {
    return VkUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      screenName: json['screen_name'],
      photo100: json['photo_100'] ?? vkUserInfo?.photo100,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['id'] = id;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['screen_name'] = screenName;
    data['photo_100'] = photo100;
    return data;
  }

  String get displayName => /*screenName ?? */'$firstName $lastName';
}
