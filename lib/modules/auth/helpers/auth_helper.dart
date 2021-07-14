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
          title: const Text('Выход из учётной записи'),
          content:
              const Text('Вы уверены, что хотите выйти из учётной записи?'),
          actions: [
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: const Text('Нет'),
            ),
            TextButton(
              onPressed: () => logout(context),
              child: const Text('Да'),
            ),
          ],
        );
      },
    );
  }
}
