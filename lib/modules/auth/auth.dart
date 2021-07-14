import 'package:flutter/cupertino.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';

import 'models/access_token_data.dart';

class Auth {
  Auth._();

  static Future<void> destroy() async {
    await AccessTokenData.fromCache()?.remove();
    user = null;
  }

  static set user(VkUser? user) {
    _valueNotifier.value = user;
  }

  static VkUser? get user => _valueNotifier.value;

  static final _valueNotifier = ValueNotifier<VkUser?>(null);
}
