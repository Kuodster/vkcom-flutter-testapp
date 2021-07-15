import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syazanou/modules/app/routing/router.dart';
import 'package:syazanou/modules/auth/auth.dart';

class AuthHelper {
  static Future<void> logout(BuildContext context) async {
    await Auth.destroy();
    await context.router.pushAndPopUntil(
      const SplashRoute(),
      predicate: (route) => false,
    );
  }

  static void logoutWithConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content:
              const Text('Are you sure that you want to sign out of your account?'),
          actions: [
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => logout(context),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
