import 'package:flutter/cupertino.dart';
import 'package:syazanou/modules/app/routing/router.dart';
import 'package:syazanou/modules/auth/models/access_token_data.dart';

class AuthHelper {
  static Future<void> logout(BuildContext context) async {
    await AccessTokenData.fromCache().remove();
    await AutoRouter.of(context).pushAndPopUntil(
      const SplashRoute(),
      predicate: (route) => false,
    );
  }

  static void logoutWithConfirmation(BuildContext context) {}
}
