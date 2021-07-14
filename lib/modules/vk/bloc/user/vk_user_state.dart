part of 'vk_user_bloc.dart';

abstract class VkUserState extends Equatable {
  const VkUserState();

  @override
  List<Object> get props => [];
}

class VkUserLoading extends VkUserState {}

class VkUserSuccess extends VkUserState {
  final VkUser user;

  const VkUserSuccess({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class VkUserError extends VkUserState {
  final dynamic exception;

  const VkUserError({
    this.exception,
  });

  @override
  List<Object> get props => [exception];

  @override
  String toString() => 'VkUserError { $exception }';
}
