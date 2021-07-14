part of 'vk_user_bloc.dart';

abstract class VkUserEvent extends Equatable {
  const VkUserEvent();
}

class LoadUser extends VkUserEvent {
  final int userId;

  const LoadUser({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
