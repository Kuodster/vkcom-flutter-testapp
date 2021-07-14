import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syazanou/modules/app/widgets/empty_app_bar.dart';

class PageWrapper extends StatelessWidget {
  final Widget? child;
  final String? title;

  const PageWrapper({
    Key? key,
    this.child,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null
          ? const EmptyAppBar()
          : AppBar(
              brightness: Brightness.dark,
              title: Text(title!),
            ),
      body: child,
    );
  }
}
