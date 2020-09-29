import Flutter
import UIKit

public class SwiftFlutterNativeWebViewPlugin: NSObject, FlutterPlugin {
    
    var registrar: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.register(NativeWebViewFactory(registrar: registrar), withId: "com.codehashi/flutter_native_webview")
    }
}
