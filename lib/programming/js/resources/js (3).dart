import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JsResource3 extends StatefulWidget {
  const JsResource3({super.key});

  @override
  State<JsResource3> createState() => _JsResource3State();
}

class _JsResource3State extends State<JsResource3> {
  late WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: WebViewWidget(
        controller: _controller
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
                'https://www.freecodecamp.org/news/how-to-set-up-a-front-end-development-project/'),
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                _controller.runJavaScript(
                  """
            document.querySelector('header').style.display = 'none';
            document.querySelector('footer').style.display = 'none';
            """,
                );
              },
            ),
          ),
      ),
    );
  }
}
