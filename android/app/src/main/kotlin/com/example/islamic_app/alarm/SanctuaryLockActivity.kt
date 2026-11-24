package com.example.islamic_app.alarm

import android.app.Activity
import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import androidx.core.view.WindowCompat
import com.example.islamic_app.MainActivity

class SanctuaryLockActivity : Activity() {
    companion object {
        const val EXTRA_MODE = "sanctuary_mode"
        const val MODE_ADHAN = "adhan"
        const val MODE_AZKAR = "azkar"
    }

    private var adhanPresenter: AdhanLockPresenter? = null

    private val finishReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val playing = intent?.action == AdhanForegroundService.ACTION_STARTED_BROADCAST
            adhanPresenter?.updatePlayingState(playing)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        configureLockscreenWindow()
        renderIntent(intent)

        val filter = IntentFilter().apply {
            addAction(AdhanForegroundService.ACTION_STARTED_BROADCAST)
            addAction(AdhanForegroundService.ACTION_FINISHED_BROADCAST)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(finishReceiver, filter, RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(finishReceiver, filter)
        }
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        if (intent != null) {
            setIntent(intent)
            renderIntent(intent)
        }
    }

    private fun configureLockscreenWindow() {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        WindowCompat.getInsetsController(window, window.decorView).apply {
            isAppearanceLightStatusBars = false
            isAppearanceLightNavigationBars = false
        }
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.VANILLA_ICE_CREAM) {
            @Suppress("DEPRECATION")
            window.statusBarColor = Color.TRANSPARENT
            @Suppress("DEPRECATION")
            window.navigationBarColor = Color.TRANSPARENT
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
            )
        }
    }

    private fun renderIntent(intent: Intent) {
        val mode = intent.getStringExtra(EXTRA_MODE) ?: MODE_ADHAN
        if (mode == MODE_AZKAR) {
            adhanPresenter = null
            val presenter = AzkarLockPresenter(
                context = this,
                onOpenFullAzkar = { catId ->
                    openMainAppRoute("/azkar-category", """{"categoryId":"$catId"}""")
                },
                onDismiss = { finishAndRemoveTaskSafe() },
            )
            setContentView(presenter.buildView(intent))
        } else {
            val presenter = AdhanLockPresenter(
                context = this,
                onStopAdhan = { stopServiceAdhan() },
                onOpenAppRoute = { route ->
                    stopServiceAdhan()
                    openMainAppRoute(route, null)
                },
                onDismiss = {
                    stopServiceAdhan()
                    finishAndRemoveTaskSafe()
                },
            )
            adhanPresenter = presenter
            setContentView(presenter.buildView(intent))
        }
    }

    private fun stopServiceAdhan() {
        val stopIntent = Intent(this, AdhanForegroundService::class.java).apply {
            action = AdhanForegroundService.ACTION_STOP
        }
        startService(stopIntent)
    }

    private fun openMainAppRoute(route: String, argsJson: String?) {
        NativeScheduleStore.savePendingLaunchRoute(this, route, argsJson)
        val launchMain = {
            val mainIntent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
                putExtra("extra_route", route)
                putExtra("extra_args_json", argsJson)
            }
            startActivity(mainIntent)
            finishAndRemoveTaskSafe()
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val km = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            if (km.isKeyguardLocked) {
                km.requestDismissKeyguard(this, object : KeyguardManager.KeyguardDismissCallback() {
                    override fun onDismissSucceeded() = launchMain()
                    override fun onDismissError() = launchMain()
                    override fun onDismissCancelled() {}
                })
                return
            }
        }
        launchMain()
    }

    private fun finishAndRemoveTaskSafe() {
        runCatching { finishAndRemoveTask() }.onFailure { finish() }
    }

    override fun onDestroy() {
        runCatching { unregisterReceiver(finishReceiver) }
        super.onDestroy()
    }
}
