import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syazanou/modules/app/routing/router.dart';

class MaterialApplication extends StatefulWidget {
  const MaterialApplication({Key? key}) : super(key: key);

  @override
  _MaterialApplicationState createState() => _MaterialApplicationState();
}

class _MaterialApplicationState extends State<MaterialApplication> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      title: 'VK.com Client',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: const Color(0xff2787F5),
        scaffoldBackgroundColor: const Color(0xff0a0a0a),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff2787F5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff19191a),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
