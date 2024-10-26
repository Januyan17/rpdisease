// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebPage extends StatefulWidget {
//   final String url;
//   String? title;

//   WebPage({required this.url, this.title});

//   @override
//   _WebPageState createState() => _WebPageState();
// }

// class _WebPageState extends State<WebPage> {
//   late final WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition and load the passed URL.
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title ?? "WebPage"),
//       ),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpskindisease/screen/BottomNavigation/BottomNavigationScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String url;
  final String? title;

  WebPage({required this.url, this.title});

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition and load the passed URL.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if the WebView can go back
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false; // Prevent default back action
        } else {
          // Navigate to HomePage if there's no history
          Get.to(BottomNavigationScreen()); // Replace with your actual route
          return true; // Allow default back action
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "WebPage"),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
