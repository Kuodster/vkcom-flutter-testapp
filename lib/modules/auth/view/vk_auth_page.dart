import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syazanou/modules/app/routing/router.dart';
import 'package:syazanou/modules/app/widgets/empty_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

const successUrl = 'https://oauth.vk.com/blank.html';

class VkAuthPage extends StatefulWidget {
  const VkAuthPage({Key? key}) : super(key: key);

  @override
  _VkAuthPageState createState() => _VkAuthPageState();
}

class _VkAuthPageState extends State<VkAuthPage> {
  final url = Uri.https('oauth.vk.com', '/authorize', {
    'client_id': '7901607',
    'redirect_uri': successUrl,
    'display': 'mobile',
    'response_type': 'token',
    'scope': (65536 + 8192 + 2).toString(),
    'revoke': '1',
    'lang': 'en',
  });

  bool _finished = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _finished;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const EmptyAppBar(
          overlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: WebView(
          initialUrl: url.toString(),
          navigationDelegate: (request) {
            if (request.url.contains(successUrl)) {
              final uri = Uri.parse(request.url);
              if (uri.hasFragment) {
                _finished = true;
                AutoRouter.of(context).pop(Uri.splitQueryString(uri.fragment));
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
