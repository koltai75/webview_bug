// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'webview test',
        home: MyWebView(),
      );
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final WebViewController _webViewController;

  final _uris = [Uri.https('google.com'), Uri.https('facebook.com')];
  var _whichUri = 0;
  var _counter = 1;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$_counter: onPageStarted: $url')));
        print('$_counter: onPageStarted: $url');
        _counter++;
      }, onPageFinished: (url) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$_counter: onPageFinished: $url')));

        print('$_counter: onPageFinished: $url');
        _counter++;
      }))
      ..loadRequest(_uris[_whichUri]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('webview test'),
        ),
        body: WebViewWidget(controller: _webViewController),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.sync),
          onPressed: () async {
            _whichUri = 1 - _whichUri;
            await _webViewController.clearCache();
            _webViewController.loadRequest(_uris[_whichUri]);
          },
        ),
      );
}
