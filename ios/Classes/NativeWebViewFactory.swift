//
//  NativeWebViewFactory.swift
//  flutter_native_webview
//
//  Created by Giovani Granero on 29/09/20.
//

import Foundation

public class NativeWebViewFactory : NSObject, FlutterPlatformViewFactory {
    
    private var registrar: FlutterPluginRegistrar?
        
    init(registrar: FlutterPluginRegistrar?) {
        super.init()
        self.registrar = registrar
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let arguments = args as? NSDictionary
        let webviewController = FlutterNativeWebViewController(registrar: registrar!,
                                                         withFrame: frame,
                                                         viewIdentifier: viewId,
                                                         arguments: arguments!)
        return webviewController
    }
}
