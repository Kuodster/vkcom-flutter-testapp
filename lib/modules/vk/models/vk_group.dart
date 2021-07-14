class VkGroup {
  final int id;
  final String name;
  final String screenName;
  final String photo50;
  final String photo100;
  final String photo200;

  VkGroup({
    required this.id,
    required this.name,
    required this.screenName,
    required this.photo50,
    required this.photo100,
    required this.photo200,
  });

  factory VkGroup.fromJson(dynamic json) {
    return VkGroup(
      id: json['id'],
      name: json['name'],
      screenName: json['screen_name'],
      photo50: json['photo_50'],
      photo100: json['photo_100'],
      photo200: json['photo_200'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'screen_name': screenName,
      'photo_50': photo50,
      'photo_100': photo100,
      'photo_200': photo200,
    };
  }
}
