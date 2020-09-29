import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeWebView extends StatefulWidget {
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  final String initialUrl;
  final void Function(NativeWebViewController controller) onLoadStart;
  final void Function(NativeWebViewController controller) onLoadStop;
  final void Function(NativeWebViewController controller, String url, int code,
      String message) onLoadError;

  const NativeWebView(
      {Key key,
      this.gestureRecognizers,
      this.onWebViewCreated,
      @required this.initialUrl,
      this.onLoadStart,
      this.onLoadStop,
      this.onLoadError})
      : super(key: key);

  final void Function(NativeWebViewController webViewController)
      onWebViewCreated;

  @override
  _NativeWebViewState createState() => _NativeWebViewState();
}

class _NativeWebViewState extends State<NativeWebView> {
  NativeWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.codehashi/flutter_native_webview',
        onPlatformViewCreated: onPlatformCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: <String, dynamic>{
          'initialUrl': '${Uri.parse(widget.initialUrl)}',
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'com.codehashi/flutter_native_webview',
        onPlatformViewCreated: onPlatformCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: <String, dynamic>{
          'initialUrl': '${Uri.parse(widget.initialUrl)}',
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Text('$defaultTargetPlatform is not yet supported by this plugin');
  }

  Future<void> onPlatformCreated(int id) async {
    assert(id != null);
    _controller = NativeWebViewController(id, widget);
    if (widget.onWebViewCreated != null) {
      widget.onWebViewCreated(_controller);
    }
  }
}

class NativeWebViewController {
  MethodChannel _channel;

  final int id;
  final NativeWebView _webView;

  NativeWebViewController(this.id, this._webView) {
    _channel = MethodChannel('com.codehashi/flutter_native_webview_$id');
    _channel.setMethodCallHandler(handleMethod);
  }

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onLoadStart":
        if (_webView != null && _webView.onLoadStart != null) {
          _webView.onLoadStart(this);
        }
        break;
      case "onLoadStop":
        if (_webView != null && _webView.onLoadStop != null) {
          _webView.onLoadStop(this);
        }
        break;
      case "onLoadError":
        final String url = call.arguments["url"] as String;
        final int code = call.arguments["code"] as int;
        final String message = call.arguments["message"] as String;
        if (_webView != null && _webView.onLoadError != null) {
          _webView.onLoadError(this, url, code, message);
        }
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

  Future<dynamic> evaluateJavascript({@required String source}) async {
    final Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('source', () => source);
    final data = await _channel.invokeMethod('evaluateJavascript', args);
    return data;
  }
}
