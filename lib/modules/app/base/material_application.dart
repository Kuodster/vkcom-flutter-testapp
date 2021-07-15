import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syazanou/modules/app/base/themes.dart';
import 'package:syazanou/modules/app/bloc/router/app_router_bloc.dart';
import 'package:syazanou/modules/app/helpers/theme_mode_helper.dart';
import 'package:syazanou/modules/app/observers/navigation_observer.dart';
import 'package:syazanou/modules/app/routing/router.dart';
import 'package:syazanou/modules/app/service_locator.dart';

class MaterialApplication extends StatefulWidget {
  const MaterialApplication({Key? key}) : super(key: key);

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
      child: ValueListenableBuilder(
        valueListenable: ThemeModeHelper.notifier,
        builder: (context, ThemeMode value, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: _appRouter.delegate(
              navigatorObservers: () => [
                NavigationObserver(),
              ],
            ),
            routeInformationParser: _appRouter.defaultRouteParser(),
            title: 'VK.com Client',
            themeMode: value,
            theme: LightTheme.config(),
            darkTheme: DarkTheme.config(),
          );
        },
      ),
    );
  }
}
