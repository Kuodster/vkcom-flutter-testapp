import 'package:auto_route/annotations.dart';
import 'package:syazanou/modules/app/view/splash_page.dart';
import 'package:syazanou/modules/auth/view/vk_auth_page.dart';
import 'package:syazanou/modules/vk/view/vk_dashboard_page.dart';

export 'router.gr.dart';
export 'package:auto_route/auto_route.dart';
export 'package:auto_route/annotations.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: SplashPage,
      initial: true,
      path: Routes.splashPage,
    ),
    AutoRoute(
      page: VkAuthPage,
      path: Routes.vkAuthPage,
    ),
    AutoRoute(
      page: VkDashboardPage,
      path: Routes.vkDashboardPage,
    ),
  ],
)
class $AppRouter {}

class Routes {
  static const String splashPage = '/';
  static const String vkAuthPage = '/vk/implicit-flow-auth';
  static const String vkDashboardPage = '/dashboard';
}
