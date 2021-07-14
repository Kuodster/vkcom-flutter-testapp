import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:syazanou/modules/app/service_locator.dart';
import 'package:syazanou/modules/app/widgets/network_connection_status.dart';
import 'package:syazanou/modules/app/widgets/page_error.dart';
import 'package:syazanou/modules/app/widgets/page_loading.dart';
import 'package:syazanou/modules/app/widgets/page_wrapper.dart';
import 'package:syazanou/modules/vk/bloc/newsfeed/vk_newsfeed_bloc.dart';
import 'package:syazanou/modules/vk/models/vk_user.dart';
import 'package:syazanou/modules/vk/providers/vk_user_provider.dart';
import 'package:syazanou/modules/vk/repository.dart';
import 'package:syazanou/modules/vk/widgets/dashboard_loading.dart';
import 'package:syazanou/modules/vk/widgets/newsfeed/post_item.dart';
import 'package:syazanou/modules/vk/widgets/vk_user_pane.dart';

class VkDashboardPage extends StatelessWidget {
  const VkDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Моя лента',
      child: VkUserProvider(
        loadingBuilder: (_) {
          return const DashboardLoading();
        },
        child: const NetworkConnectionStatus(
          child: _InnerPage(),
        ),
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

  VkUser get vkUser => Provider.of<VkUser>(context);

  final _scrollToTopVisible = ValueNotifier<bool>(false);

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
        const SizedBox(height: 10.0),
        VkUserPane(vkUser: vkUser),
        const SizedBox(height: 10.0),
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
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'Ваша лента пуста',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                          itemBuilder: (context, index) {
                            if (index >= state.feedData.items.length) {
                              if (state.hasReachedMax) {
                                return const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      'На этом всё! Возвращайтесь позже.',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
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
