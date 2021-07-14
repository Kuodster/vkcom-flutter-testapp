import 'package:flutter/material.dart';
import 'package:syazanou/modules/auth/helpers/auth_helper.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';

class VkUserPane extends StatelessWidget {
  final VkUser vkUser;

  const VkUserPane({
    Key? key,
    required this.vkUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[800],
            backgroundImage:
                vkUser.photo100 != null ? NetworkImage(vkUser.photo100!) : null,
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  vkUser.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                if (vkUser.phone != null) ...[
                  const SizedBox(height: 5.0),
                  Text(
                    vkUser.phone!,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => AuthHelper.logoutWithConfirmation(context),
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
