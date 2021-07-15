import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syazanou/modules/app/base/material_application.dart';
import 'package:syazanou/modules/app/cache.dart';
import 'package:syazanou/modules/app/helpers/theme_mode_helper.dart';
import 'package:syazanou/modules/app/intl.dart';
import 'package:syazanou/modules/app/logging/log.dart';
import 'package:syazanou/modules/app/observers/bloc_debug_observer.dart';
import 'package:syazanou/modules/app/service_locator.dart';

void main() async {
  Log.initialize();
  await ServiceLocator.initialize();
  await Cache.initialize();
  Intl.initialize();
  ThemeModeHelper.setupSystemNavigation();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  if (kDebugMode) {
    Bloc.observer = BlocDebugObserver();
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    Log.w(details);
    if (kReleaseMode) {
      exit(1);
    }
  };

  runApp(const MaterialApplication());
}
