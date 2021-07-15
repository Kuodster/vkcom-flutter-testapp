import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syazanou/modules/app/helpers/theme_mode_helper.dart';
import 'package:syazanou/modules/app/service_locator.dart';
import 'package:syazanou/modules/app/widgets/network_connection_status.dart';
import 'package:syazanou/modules/app/widgets/page_error.dart';
import 'package:syazanou/modules/app/widgets/page_loading.dart';
import 'package:syazanou/modules/app/widgets/page_wrapper.dart';
import 'package:syazanou/modules/auth/auth.dart';
import 'package:syazanou/modules/vk/bloc/newsfeed/vk_newsfeed_bloc.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';
import 'package:syazanou/modules/vk/repository.dart';
import 'package:syazanou/modules/vk/widgets/newsfeed/post_item.dart';
import 'package:syazanou/modules/vk/widgets/vk_user_pane.dart';

class VkDashboardPage extends StatelessWidget {
  const VkDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'My Newsfeed',
      actions: [
        IconButton(
          onPressed: ThemeModeHelper.opposite,
          icon: ValueListenableBuilder(
            valueListenable: ThemeModeHelper.notifier,
            builder: (context, ThemeMode value, _) => Icon(
              value == ThemeMode.dark
                  ? Icons.brightness_4
                  : Icons.brightness_4_outlined,
            ),
          ),
        ),
      ],
      child: const NetworkConnectionStatus(
        child: _InnerPage(),
      ),
    );
  }
}

class _InnerPage extends StatefulWidget {
  const _InnerPage({Key? key}) : super(key: key);

  @override
  __InnerPageState createState() => __InnerPageState();
}

class __InnerPageState extends State<_InnerPage> {
  final _controller = ScrollController();
  final _bloc = VkNewsfeedBloc(
    repository: ServiceLocator.get<VkRepository>(),
  );

  final _scrollToTopVisible = ValueNotifier<bool>(false);

  VkUser? get userProfile => Auth.user;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _bloc.close();
    _scrollToTopVisible.dispose();
    super.dispose();
  }

  void _loadData() {
    _bloc.add(ResetFeed());
  }

  void _onScroll() {
    if (_bloc.state is VkNewsfeedSuccess &&
        _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _bloc.add(const LoadNewsfeed());
    }

    final size = MediaQuery.of(context).size;
    final scrollToTopVisibilityOffset = size.height * 3;

    if (!_scrollToTopVisible.value &&
        _controller.offset >= scrollToTopVisibilityOffset) {
      _scrollToTopVisible.value = true;
    } else if (_scrollToTopVisible.value &&
        _controller.offset < scrollToTopVisibilityOffset) {
      _scrollToTopVisible.value = false;
    }
  }

  void _scrollToTop() {
    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  void _onLikeButtonPressed(String type, int itemId, int? ownerId,
      [bool isDelete = false]) {
    _bloc.add(LikePressed(
      type: type,
      itemId: itemId,
      ownerId: ownerId,
      actionType: isDelete ? LikeType.remove : LikeType.add,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (userProfile != null) ...[
          const SizedBox(height: 10.0),
          VkUserPane(vkUser: userProfile!),
        ],
        Expanded(
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, state) {
              if (state is VkNewsfeedLoading) {
                return const PageLoading();
              }
              if (state is VkNewsfeedError) {
                return PageError(
                  exception: state.exception,
                  onRefresh: _loadData,
                );
              }

              if (state is VkNewsfeedSuccess) {
                if (state.feedData.items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'Your newsfeed is empty',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  );
                }

                return Stack(
                  children: [
                    Positioned.fill(
                      child: RefreshIndicator(
                        onRefresh: () async => _loadData(),
                        child: ListView.separated(
                          cacheExtent: MediaQuery.of(context).size.height * 4,
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _controller,
                          itemCount: state.feedData.items.length + 1,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          itemBuilder: (context, index) {
                            if (index >= state.feedData.items.length) {
                              if (state.hasReachedMax) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      'That\'s all for now! Come back later.',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final element =
                                state.feedData.items.elementAt(index);

                            switch (element.type) {
                              case 'post':
                                return PostItem(
                                  newsfeedItem: element,
                                  groups: state.feedData.groups,
                                  profiles: state.feedData.profiles,
                                  onLike: (isDelete) => _onLikeButtonPressed(
                                    element.type,
                                    element.postId,
                                    element.sourceId,
                                    isDelete,
                                  ),
                                );
                              default:
                                return Container(
                                  height: 100.0,
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                );
                            }
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10.0),
                        ),
                      ),
                    ),
                    Positioned(
                      child: ValueListenableBuilder(
                        valueListenable: _scrollToTopVisible,
                        builder: (context, bool value, child) {
                          const placeholder = SizedBox();
                          return value ? (child ?? placeholder) : placeholder;
                        },
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[800],
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(5.0),
                          ),
                          onPressed: _scrollToTop,
                          child: const Icon(
                            Icons.arrow_upward_outlined,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                      bottom: 0.0,
                      right: 10.0,
                    ),
                  ],
                );
              }

              return Container();
            },
          ),
        ),
      ],
    );
  }
}
