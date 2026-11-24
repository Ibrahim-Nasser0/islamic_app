package com.example.islamic_app

import android.content.Intent
import com.example.islamic_app.alarm.NativeMethodChannelHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var nativeHandler: NativeMethodChannelHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        nativeHandler = NativeMethodChannelHandler(
            context = applicationContext,
            messenger = flutterEngine.dartExecutor.binaryMessenger,
        )
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val route = intent.getStringExtra("extra_route")
        val argsJson = intent.getStringExtra("extra_args_json")
        if (!route.isNullOrEmpty()) {
            nativeHandler?.dispatchOpenRoute(route, argsJson)
        }
    }
}
