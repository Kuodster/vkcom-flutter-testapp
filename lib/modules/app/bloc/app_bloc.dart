import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:syazanou/http/http.dart';
import 'package:syazanou/modules/app/cache.dart';
import 'package:syazanou/modules/auth/auth.dart';
import 'package:syazanou/modules/auth/models/access_token_data.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';
import 'package:syazanou/modules/vk/models/vk_user_info.dart';
import 'package:syazanou/modules/vk/repository.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late Box accessTokenBox;
  final VkRepository repository;

  AppBloc({
    required this.repository,
  }) : super(AppLoading()) {
    accessTokenBox = Cache.box<AccessTokenData>();
  }

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is StartApplication) {
      yield AppLoading();

      await Future<void>.delayed(const Duration(milliseconds: 1300));

      try {
        // Check if the app has any access token stored
        final token = AccessTokenData.fromCache();

        if (token != null) {
          final profileResponse = await repository.getProfileInfo();
          final userResponse = await repository.getUser(userId: token.userId);

          final userJson = (userResponse as List).first;
          final profile = VkUser.fromJson(
            profileResponse,
            VkUserInfo.fromJson(userJson),
          );

          Auth.user = profile;

          yield AppAuthenticated();
        } else {
          yield AppUnauthenticated();
          return;
        }
      } catch (e) {
        if (e is DioError && e.type == DioErrorType.other) {
          final exception = e.error;
          if (exception is ApiException && [5, 28].contains(exception.error)) {
            await Auth.destroy();
            yield AppUnauthenticated();
            return;
          }
        }
        yield AppStartupFailed(exception: e);
      }
    }

    if (event is SaveAccessToken) {
      await accessTokenBox.put(
        AccessTokenData.cacheBoxKey,
        event.accessTokenData,
      );
      add(StartApplication());
    }

    if (event is AuthenticationFailed) {
      yield AppAuthenticationUserCancelled();
    }
  }
}
