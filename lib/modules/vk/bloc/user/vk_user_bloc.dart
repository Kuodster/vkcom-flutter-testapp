import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';
import 'package:syazanou/modules/vk/models/vk_user_info.dart';
import 'package:syazanou/modules/vk/repository.dart';

part 'vk_user_event.dart';

part 'vk_user_state.dart';

class VkUserBloc extends Bloc<VkUserEvent, VkUserState> {
  final VkRepository repository;

  VkUserBloc({
    required this.repository,
  }) : super(VkUserLoading());

  @override
  Stream<VkUserState> mapEventToState(
    VkUserEvent event,
  ) async* {
    if (event is LoadUser) {
      yield VkUserLoading();
      try {
        final profileResponse = await repository.getProfileInfo();
        final userResponse = await repository.getUser(userId: event.userId);

        final userJson = (userResponse as List).first;
        final profile = VkUser.fromJson(
          profileResponse,
          VkUserInfo.fromJson(userJson),
        );

        yield VkUserSuccess(
          user: profile,
        );
      } catch (e) {
        yield VkUserError(exception: e);
      }
    }
  }
}
