part of 'app_router_bloc.dart';

typedef AsyncCallbackWithRouter = Future<void> Function(AppRouter);

abstract class AppRouterEvent extends Equatable {
  const AppRouterEvent();
}

class RoutingEvent extends AppRouterEvent {
  final AsyncCallbackWithRouter callback;

  const RoutingEvent({
    required this.callback,
  });

  @override
  List<Object?> get props => [callback];
}
