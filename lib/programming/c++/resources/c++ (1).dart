import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CppResource1 extends StatefulWidget {
  const CppResource1({super.key});

  @override
  State<CppResource1> createState() => _CppResource1State();
}

class _CppResource1State extends State<CppResource1> {
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
                'https://www.geeksforgeeks.org/introduction-to-c-programming-language/'),
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
