import 'package:flutter/material.dart';

class StatCounter extends StatelessWidget {
  final Widget? icon;
  final int count;

  const StatCounter({
    Key? key,
    required this.count,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 10.0),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        ],
      ),
    );
  }
}
