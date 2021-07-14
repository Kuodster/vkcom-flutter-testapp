import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:syazanou/modules/app/service_locator.dart';
import 'package:syazanou/modules/app/widgets/page_error.dart';
import 'package:syazanou/modules/app/widgets/page_loading.dart';
import 'package:syazanou/modules/auth/models/access_token_data.dart';
import 'package:syazanou/modules/vk/bloc/user/vk_user_bloc.dart';
import 'package:syazanou/modules/vk/repository.dart';

class VkUserProvider extends StatefulWidget {
  final Widget? child;
  final WidgetBuilder? loadingBuilder;

  const VkUserProvider({
    Key? key,
    this.child,
    this.loadingBuilder,
  }) : super(key: key);

  @override
  _VkUserProviderState createState() => _VkUserProviderState();
}

class _VkUserProviderState extends State<VkUserProvider> {
  final _bloc = VkUserBloc(
    repository: ServiceLocator.get<VkRepository>(),
  );

  final _accessTokenData = AccessTokenData.fromCache();

  Widget? get child => widget.child;

  WidgetBuilder? get loadingBuilder => widget.loadingBuilder;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    _bloc.add(LoadUser(userId: _accessTokenData.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is VkUserLoading) {
          return loadingBuilder != null
              ? loadingBuilder!(context)
              : const PageLoading();
        }
        if (state is VkUserError) {
          return PageError(
            exception: state.exception,
            onRefresh: _loadData,
          );
        }
        if (state is VkUserSuccess) {
          return Provider(
            create: (_) => state.user,
            child: child,
          );
        }
        return Container();
      },
    );
  }
}
