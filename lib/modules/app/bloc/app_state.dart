part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppLoading extends AppState {}

class AppStartupFailed extends AppState {
  final dynamic exception;

  const AppStartupFailed({
    this.exception,
  });

  @override
  List<Object> get props => [exception];

  @override
  String toString() => 'AppStartupFailed { $exception }';
}

class AppUnauthenticated extends AppState {}

class AppAuthenticated extends AppState {}
