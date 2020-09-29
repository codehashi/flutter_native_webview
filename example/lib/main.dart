import 'package:flutter/material.dart';
import 'package:flutter_native_webview/native_webview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SafeArea(
              child: NativeWebView(
        initialUrl: "https://www.google.com",
        onLoadStop: (controller) async {
          final content = await controller.evaluateJavascript(
              source: 'document.documentElement.outerHTML');
          print(content);
        },
      ))),
    );
  }
}
