//
//  NativeWebViewController.swift
//  flutter_native_webview
//
//  Created by Giovani Granero on 29/09/20.
//

import Foundation
import WebKit

public class FlutterNativeWebViewController : FlutterMethodCallDelegate, FlutterPlatformView {
    
    private weak var registrar: FlutterPluginRegistrar?
    var webView: FlutterNativeWebView?
    var viewId: Any = 0
    var channel: FlutterMethodChannel?
    
    init(registrar: FlutterPluginRegistrar, withFrame frame: CGRect, viewIdentifier viewId: Any, arguments args: NSDictionary) {
        super.init()
        
        self.registrar = registrar
        self.viewId = viewId
        
        var channelName = ""
        if let id = viewId as? Int64 {
            channelName = "com.codehashi/flutter_native_webview_" + String(id)
        } else if let id = viewId as? String {
            channelName = "com.codehashi/flutter_native_webview_" + id
        }
        channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        channel!.setMethodCallHandler(LeakAvoider(delegate: self).handle)
        
        let initialUrl = args["initialUrl"] as! String?
        
        let url = initialUrl ?? "about:blank"
        
        let configuration = WKWebViewConfiguration()
        configuration.limitsNavigationsToAppBoundDomains = true
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        let request = URLRequest(url: URL(string: url)!)
        
        webView = FlutterNativeWebView(frame: CGRect.zero, configuration: configuration, channel: channel)
        
        webView?.cleanAllCookies()
        webView?.refreshCookies()
        
        webView?.load(request)
    }
    
    public func view() -> UIView {
        return webView ?? WKWebView()
    }
    
    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        switch call.method {
            case "evaluateJavascript":
                let source = (arguments!["source"] as? String)!
                webView?.evaluateJavaScript(source, flutterResult: result)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }
}
