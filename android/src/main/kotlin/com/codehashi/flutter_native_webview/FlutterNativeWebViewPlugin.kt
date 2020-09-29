package com.codehashi.flutter_native_webview

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformViewRegistry

class FlutterNativeWebViewPlugin : FlutterPlugin, ActivityAware {

  fun registerWith(registrar: PluginRegistry.Registrar) {
    onAttachedToEngine(
            registrar.messenger(), registrar.platformViewRegistry())
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(messenger = binding.binaryMessenger, platformViewRegistry = binding.platformViewRegistry)
  }

  private fun onAttachedToEngine(messenger: BinaryMessenger, platformViewRegistry: PlatformViewRegistry) {
    platformViewRegistry.registerViewFactory("com.codehashi/flutter_native_webview", FlutterNativeWebViewFactory(messenger = messenger))
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }

}
