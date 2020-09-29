#import "FlutterNativeWebViewPlugin.h"
#if __has_include(<flutter_native_webview/flutter_native_webview-Swift.h>)
#import <flutter_native_webview/flutter_native_webview-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_native_webview-Swift.h"
#endif

@implementation FlutterNativeWebViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterNativeWebViewPlugin registerWithRegistrar:registrar];
}
@end
