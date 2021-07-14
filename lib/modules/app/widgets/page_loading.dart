import 'package:flutter/material.dart';
import 'package:syazanou/modules/app/widgets/loading_indicator.dart';

class PageLoading extends StatelessWidget {
  const PageLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: SizedBox(
          height: 40.0,
          width: 40.0,
          child: FittedBox(
            child: LoadingIndicator(),
          ),
        ),
      ),
    );
  }
}
