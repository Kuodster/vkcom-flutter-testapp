import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:syazanou/modules/app/routing/router.dart';

part 'app_router_event.dart';

part 'app_router_state.dart';

class AppRouterBloc extends Bloc<AppRouterEvent, AppRouterState> {
  AppRouterBloc() : super(AppRouterInitial());

  @override
  Stream<AppRouterState> mapEventToState(
    AppRouterEvent event,
  ) async* {
    if (event is RoutingEvent) {
      yield AppRouterCallback(callback: event.callback);
    }
  }
}
