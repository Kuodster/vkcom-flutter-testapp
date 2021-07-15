import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syazanou/modules/app/bloc/router/app_router_bloc.dart';
import 'package:syazanou/modules/app/observers/navigation_observer.dart';
import 'package:syazanou/modules/app/routing/router.dart';
import 'package:syazanou/modules/app/service_locator.dart';

class MaterialApplication extends StatefulWidget {
  const MaterialApplication({Key? key}) : super(key: key);

  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  _MaterialApplicationState createState() => _MaterialApplicationState();
}

class _MaterialApplicationState extends State<MaterialApplication> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: ServiceLocator.get<AppRouterBloc>(),
      listener: (context, state) {
        if (state is AppRouterCallback) {
          state.callback(_appRouter);
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: MaterialApplication.scaffoldMessengerKey,
        routerDelegate: _appRouter.delegate(
          navigatorObservers: () => [
            NavigationObserver(),
          ],
        ),
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
          dialogTheme: const DialogTheme(
            backgroundColor: Color(0xff19191a),
            titleTextStyle: TextStyle(
              color: Colors.white70,
            ),
            contentTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
