import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syazanou/modules/app/bloc/app_bloc.dart';
import 'package:syazanou/modules/app/routing/router.dart';
import 'package:syazanou/modules/app/service_locator.dart';
import 'package:syazanou/modules/app/widgets/loading_indicator.dart';
import 'package:syazanou/modules/app/widgets/page_error.dart';
import 'package:syazanou/modules/app/widgets/page_wrapper.dart';
import 'package:syazanou/modules/app/widgets/styled_button.dart';
import 'package:syazanou/modules/auth/models/access_token_data.dart';
import 'package:syazanou/modules/vk/repository.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageWrapper(
      child: _Inner(),
    );
  }
}

class _Inner extends StatefulWidget {
  const _Inner({Key? key}) : super(key: key);

  @override
  __InnerState createState() => __InnerState();
}

class __InnerState extends State<_Inner> {
  final _appBloc = AppBloc(
    repository: ServiceLocator.get<VkRepository>(),
  );

  Future<void> _startAuthentication() async {
    final result = await AutoRouter.of(context).pushNamed(Routes.vkAuthPage);
    if (result is Map) {
      if (result.containsKey('access_token')) {
        final accessTokenData = AccessTokenData.fromJson(result);
        _appBloc.add(SaveAccessToken(accessTokenData: accessTokenData));
        return;
      }
    }
    _appBloc.add(AuthenticationFailed());
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _startApplication();
    });
  }

  void _startApplication() {
    _appBloc.add(StartApplication());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _appBloc,
      listener: (context, state) {
        if (state is AppUnauthenticated) {
          _startAuthentication();
        }
        if (state is AppAuthenticated) {
          context.router.replaceNamed(Routes.vkDashboardPage);
        }
      },
      builder: (context, state) {
        if (state is AppStartupFailed) {
          return PageError(
            exception: state.exception,
            onRefresh: _startApplication,
          );
        }
        final showLoginButton = state is AppAuthenticationUserCancelled;

        return SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/vk.com-logo.png',
                  width: 100.0,
                ),
                const SizedBox(height: 20.0),
                showLoginButton
                    ? StyledButton(
                        onTap: _startAuthentication,
                        label: 'Sign in',
                      )
                    : SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: FittedBox(
                          child: LoadingIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
