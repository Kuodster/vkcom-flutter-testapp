import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:syazanou/modules/app/cache.dart';
import 'package:syazanou/modules/auth/models/access_token_data.dart';
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
        final token = accessTokenBox.get(AccessTokenData.cacheBoxKey);

        if (token != null) {
          yield AppAuthenticated();
        } else {
          yield AppUnauthenticated();
          return;
        }
      } catch (e) {
        yield AppStartupFailed(exception: e);
      }
    }

    if (event is SaveAccessToken) {
      await accessTokenBox.put(
        AccessTokenData.cacheBoxKey,
        event.accessTokenData,
      );
      yield AppAuthenticated();
    }
  }
}
