import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:syazanou/modules/app/logging/log.dart';
import 'package:syazanou/modules/vk/models/vk_newsfeed_data.dart';
import 'package:syazanou/modules/vk/models/vk_newsfeed_item.dart';
import 'package:syazanou/modules/vk/repository.dart';

part 'vk_newsfeed_event.dart';

part 'vk_newsfeed_state.dart';

class VkNewsfeedBloc extends Bloc<VkNewsfeedEvent, VkNewsfeedState> {
  final VkRepository repository;

  String? nextPage;

  VkNewsfeedBloc({
    required this.repository,
  }) : super(VkNewsfeedLoading());

  bool hasReachedMax(VkNewsfeedState state) =>
      state is VkNewsfeedSuccess && state.hasReachedMax;

  @override
  Stream<VkNewsfeedState> mapEventToState(
    VkNewsfeedEvent event,
  ) async* {
    if (event is LikePressed) {
      if (state is VkNewsfeedSuccess) {
        try {
          dynamic response;
          if (event.actionType == LikeType.add) {
            response = await repository.likeAdd(
              type: event.type,
              itemId: event.itemId,
              ownerId: event.ownerId,
            );
          } else {
            response = await repository.likeDelete(
              type: event.type,
              itemId: event.itemId,
              ownerId: event.ownerId,
            );
          }
          yield (state as VkNewsfeedSuccess).replaceLikesInItems(
            type: event.type,
            itemId: event.itemId,
            likes: VkNewsfeedItemLikes(
              count: response['likes'],
              userLikes: event.actionType == LikeType.add,
              canLike: true,
            ),
          );
        } catch (e, trace) {
          Log.d(e);
          Log.d(trace);
        }
      }
    }

    if (event is ResetFeed) {
      nextPage = null;
      yield VkNewsfeedLoading();
      add(const LoadNewsfeed());
    }
    if (event is LoadNewsfeed && !hasReachedMax(state)) {
      if (state is VkNewsfeedSuccess) {
        final response = await repository.getNewsfeed(
          pageSize: event.pageSize,
          startFrom: nextPage,
        );
        final feedData = VkNewsfeedData.fromJson(response);
        yield (state as VkNewsfeedSuccess).mergeWith(
          hasReachedMax: feedData.isLastPage,
          feedData: feedData,
        );

        nextPage = feedData.nextFrom;
      } else {
        yield VkNewsfeedLoading();
        try {
          final response =
              await repository.getNewsfeed(pageSize: event.pageSize);
          final feedData = VkNewsfeedData.fromJson(response);
          yield VkNewsfeedSuccess(
            feedData: feedData,
            hasReachedMax: feedData.nextFrom == null,
          );

          nextPage = feedData.nextFrom;
        } catch (e, trace) {
          Log.d(trace);
          yield VkNewsfeedError(exception: e);
        }
      }
    }
  }
}
