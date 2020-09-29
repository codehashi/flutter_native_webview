package com.codehashi.flutter_native_webview

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.os.Build
import android.view.View
import android.webkit.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.apache.commons.text.StringEscapeUtils

@SuppressLint("SetJavaScriptEnabled")
class FlutterNativeWebView(messenger: BinaryMessenger, context: Context?, id: Int, params: HashMap<String, Any>?): PlatformView, MethodChannel.MethodCallHandler {

    val channel: MethodChannel = MethodChannel(messenger, "com.codehashi/flutter_native_webview_$id")
    private val webView: WebView

    init {
        channel.setMethodCallHandler(this)
        val initialUrl = params?.get("initialUrl") as String?
        webView = WebView(context)
        val loginWebViewClient = LoginWebViewClient()
        webView.webViewClient = loginWebViewClient
        webView.settings.javaScriptEnabled = true
        webView.settings.cacheMode = WebSettings.LOAD_NO_CACHE
        clearCookies(context)
        webView.loadUrl(initialUrl)
    }

    override fun getView(): View {
        return webView
    }

    override fun dispose() {}

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "evaluateJavascript" -> {
                val source = call.argument<String>("source")
                webView.evaluateJavascript(source) {
                    val unescapedValue = StringEscapeUtils.unescapeJava(it)
                    result.success(unescapedValue)
                }
            }
            else -> result.notImplemented()
        }
    }

    @SuppressWarnings("deprecation")
    private fun clearCookies(context: Context?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            val cookieManager = CookieManager.getInstance()
            cookieManager.removeAllCookies(null)
            cookieManager.flush()
        } else if (context != null) {
            val cookieSyncManager = CookieSyncManager.createInstance(context)
            cookieSyncManager.startSync()
            val cookieManager: CookieManager = CookieManager.getInstance()
            cookieManager.removeAllCookie()
            cookieManager.removeSessionCookie()
            cookieSyncManager.stopSync()
            cookieSyncManager.sync()
        }
    }

    inner class LoginWebViewClient : WebViewClient() {
        override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
            channel.invokeMethod("onLoadStart", null)
            super.onPageStarted(view, url, favicon)
        }

        override fun onPageFinished(view: WebView?, url: String?) {
            channel.invokeMethod("onLoadStop", null)
            super.onPageFinished(view, url)
        }

        override fun onReceivedError(view: WebView?, errorCode: Int, description: String?, failingUrl: String?) {
            val obj: HashMap<String, Any?> = HashMap()
            obj["url"] = failingUrl
            obj["code"] = errorCode;
            obj["message"] = description;
            channel.invokeMethod("onLoadError", obj)

            super.onReceivedError(view, errorCode, description, failingUrl);
        }
    }
}