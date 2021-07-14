import 'package:flutter/cupertino.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';

class Auth {
  Auth._();

  static void destroy() {
    user = null;
  }

  static set user(VkUser? user) {
    _valueNotifier.value = user;
  }

  static VkUser? get user => _valueNotifier.value;

  static final _valueNotifier = ValueNotifier<VkUser?>(null);
}
