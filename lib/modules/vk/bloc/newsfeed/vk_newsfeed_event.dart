part of 'vk_newsfeed_bloc.dart';

abstract class VkNewsfeedEvent extends Equatable {
  const VkNewsfeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadNewsfeed extends VkNewsfeedEvent {
  final int pageSize;

  const LoadNewsfeed({
    this.pageSize = 15,
  });

  @override
  List<Object?> get props => [pageSize];
}

class ResetFeed extends VkNewsfeedEvent {}

enum LikeType { add, remove }

class LikePressed extends VkNewsfeedEvent {
  final String type;
  final int itemId;
  final int? ownerId;

  final LikeType? actionType;

  const LikePressed({
    required this.type,
    required this.itemId,
    this.ownerId,
    this.actionType = LikeType.add,
  });

  @override
  List<Object?> get props => [
        type,
        itemId,
        ownerId,
        actionType,
      ];
}
