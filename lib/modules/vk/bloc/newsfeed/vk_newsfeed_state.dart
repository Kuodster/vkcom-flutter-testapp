part of 'vk_newsfeed_bloc.dart';

abstract class VkNewsfeedState extends Equatable {
  const VkNewsfeedState();

  @override
  List<Object> get props => [];
}

class VkNewsfeedLoading extends VkNewsfeedState {}

class VkNewsfeedError extends VkNewsfeedState {
  final dynamic exception;

  const VkNewsfeedError({
    this.exception,
  });

  @override
  List<Object> get props => [exception];

  @override
  String toString() => 'VkNewsfeedError { $exception }';
}

class VkNewsfeedSuccess extends VkNewsfeedState {
  final VkNewsfeedData feedData;
  final bool hasReachedMax;

  const VkNewsfeedSuccess({
    required this.feedData,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [feedData];

  VkNewsfeedSuccess mergeWith({
    required VkNewsfeedData feedData,
    bool? hasReachedMax,
  }) {
    return VkNewsfeedSuccess(
      feedData: this.feedData.mergeWith(feedData),
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  VkNewsfeedSuccess replaceLikesInItems({
    required String type,
    required int itemId,
    required VkNewsfeedItemLikes likes,
  }) {
    final index = feedData.items.indexWhere(
        (element) => element.type == type && element.postId == itemId);
    if (index > -1) {
      final item = feedData.items.elementAt(index);
      item.likes = likes;
      final itemsCopy = [...feedData.items];
      itemsCopy[index] = item;

      return VkNewsfeedSuccess(
        feedData: VkNewsfeedData(
          items: itemsCopy,
          groups: feedData.groups,
          profiles: feedData.profiles,
        ),
      );
    }
    return this;
  }
}
