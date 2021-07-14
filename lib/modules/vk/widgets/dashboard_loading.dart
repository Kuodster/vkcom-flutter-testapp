import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        const _UserPane(),
        const SizedBox(height: 10.0),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}

class _UserPane extends StatelessWidget {
  const _UserPane({Key? key}) : super(key: key);

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
          _Shimmer(
            child: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Shimmer(
                  child: Container(
                    color: Colors.grey[800],
                    height: 5.0,
                    width: 150.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                _Shimmer(
                  child: Container(
                    color: Colors.grey[900],
                    height: 5.0,
                    width: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final Widget child;

  const _Shimmer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white30,
      highlightColor: Colors.white54,
      child: child,
    );
  }
}
