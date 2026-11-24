package com.example.islamic_app.alarm

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.lang.ref.WeakReference

class NativeMethodChannelHandler(
    private val context: Context,
    messenger: BinaryMessenger,
    activity: Activity? = null,
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, CHANNEL_NAME)
    private val activityRef = WeakReference(activity)
    private var pendingNotifResult: MethodChannel.Result? = null

    companion object {
        const val CHANNEL_NAME = "com.example.islamic_app/native_alarms"
        private const val REQ_POST_NOTIFICATIONS = 9401
    }

    init {
        channel.setMethodCallHandler(this)
    }

    fun dispatchOpenRoute(route: String, argsJson: String?) {
        val argsMap = if (argsJson != null) {
            runCatching {
                val obj = JSONObject(argsJson)
                val map = mutableMapOf<String, Any?>()
                val keys = obj.keys()
                while (keys.hasNext()) {
                    val k = keys.next()
                    map[k] = obj.opt(k)
                }
                map
            }.getOrNull()
        } else {
            null
        }
        channel.invokeMethod("openRoute", mapOf("route" to route, "args" to argsMap))
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "syncPrayerSchedule" -> {
                val args = call.arguments as? Map<*, *>
                if (args == null) {
                    result.success(false)
                    return
                }
                NativeAlarmScheduler.syncAndSchedulePrayers(context, JSONObject(args))
                result.success(true)
            }
            "syncAzkarSchedule" -> {
                val args = call.arguments as? Map<*, *>
                if (args == null) {
                    result.success(false)
                    return
                }
                NativeAlarmScheduler.syncAndScheduleAzkar(context, JSONObject(args))
                result.success(true)
            }
            "cancelPrayerAlarms" -> {
                NativeAlarmScheduler.cancelAllPrayerAlarms(context)
                result.success(null)
            }
            "cancelAzkarAlarms" -> {
                NativeAlarmScheduler.cancelAllAzkarAlarms(context)
                result.success(null)
            }
            "consumePendingLaunchRoute" -> {
                result.success(NativeScheduleStore.consumePendingLaunchRoute(context))
            }
            "consumeDhikrUpdates" -> {
                result.success(NativeScheduleStore.consumeDhikrUpdates(context))
            }
            "checkReliability" -> {
                result.success(NativeAlarmScheduler.checkReliability(context))
            }
            "requestNotificationPermission" -> {
                handleRequestNotificationPermission(result)
            }
            "openBatterySettings" -> {
                NativeAlarmScheduler.openBatterySettings(context)
                result.success(null)
            }
            "openNotificationSettings" -> {
                NativeAlarmScheduler.openNotificationSettings(context)
                result.success(null)
            }
            "openExactAlarmSettings" -> {
                NativeAlarmScheduler.openExactAlarmSettings(context)
                result.success(null)
            }
            "openFullScreenIntentSettings" -> {
                NativeAlarmScheduler.openFullScreenIntentSettings(context)
                result.success(null)
            }
            "previewNativeAdhan" -> {
                val args = call.arguments as? Map<*, *> ?: emptyMap<String, Any>()
                triggerPreviewAdhan(JSONObject(args))
                result.success(null)
            }
            "previewNativeAzkar" -> {
                val args = call.arguments as? Map<*, *> ?: emptyMap<String, Any>()
                triggerPreviewAzkar(JSONObject(args))
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun triggerPreviewAdhan(payload: JSONObject) {
        val prayerKey = payload.optString("prayerKey", "fajr")
        val titleAr = payload.optString("titleAr", "الفجر")
        val titleEn = payload.optString("titleEn", "Fajr")
        val timeMillis = payload.optLong("prayerTimeMillis", System.currentTimeMillis())
        val rawSound = payload.optString("rawSound", "al_harram_fajr")
        val lang = payload.optString("languageCode", "ar")
        val muezzinAr = payload.optString("muezzinNameAr", "أذان الحرم المكي")
        val muezzinEn = payload.optString("muezzinNameEn", "Makkah Sanctuary")
        val muezzinLoc = payload.optString("muezzinLocation", "مكة المكرمة")

        val serviceIntent = Intent(context, AdhanForegroundService::class.java).apply {
            action = AdhanForegroundService.ACTION_START
            putExtra("prayerKey", prayerKey)
            putExtra("titleAr", titleAr)
            putExtra("titleEn", titleEn)
            putExtra("prayerTimeMillis", timeMillis)
            putExtra("rawSound", rawSound)
            putExtra("lockscreenEnabled", false)
            putExtra("languageCode", lang)
            putExtra("muezzinNameAr", muezzinAr)
            putExtra("muezzinNameEn", muezzinEn)
            putExtra("muezzinLocation", muezzinLoc)
        }
        ContextCompat.startForegroundService(context, serviceIntent)

        val lockIntent = Intent(context, SanctuaryLockActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(SanctuaryLockActivity.EXTRA_MODE, SanctuaryLockActivity.MODE_ADHAN)
            putExtra("prayerKey", prayerKey)
            putExtra("titleAr", titleAr)
            putExtra("titleEn", titleEn)
            putExtra("prayerTimeMillis", timeMillis)
            putExtra("languageCode", lang)
            putExtra("muezzinNameAr", muezzinAr)
            putExtra("muezzinNameEn", muezzinEn)
            putExtra("muezzinLocation", muezzinLoc)
        }
        context.startActivity(lockIntent)
    }

    private fun triggerPreviewAzkar(payload: JSONObject) {
        val categoryId = payload.optString("categoryId", "morning")
        val lang = payload.optString("languageCode", "ar")
        if (payload.has("items")) {
            val wrapped = NativeScheduleStore.loadAzkarPayload(context) ?: JSONObject()
            val key = if (categoryId == "evening") "eveningItems" else "morningItems"
            wrapped.put(key, payload.optJSONArray("items"))
            NativeScheduleStore.saveAzkarPayload(context, wrapped.toString())
        }
        val lockIntent = Intent(context, SanctuaryLockActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(SanctuaryLockActivity.EXTRA_MODE, SanctuaryLockActivity.MODE_AZKAR)
            putExtra("categoryId", categoryId)
            putExtra("languageCode", lang)
        }
        context.startActivity(lockIntent)
    }

    private fun handleRequestNotificationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(true)
            return
        }
        val granted = ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.POST_NOTIFICATIONS,
        ) == PackageManager.PERMISSION_GRANTED
        if (granted) {
            result.success(true)
            return
        }
        val act = activityRef.get()
        if (act == null || act.isFinishing || act.isDestroyed) {
            result.success(false)
            return
        }
        pendingNotifResult?.success(false)
        pendingNotifResult = result
        ActivityCompat.requestPermissions(
            act,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            REQ_POST_NOTIFICATIONS,
        )
    }

    fun onRequestPermissionsResult(requestCode: Int, grantResults: IntArray) {
        if (requestCode != REQ_POST_NOTIFICATIONS) return
        val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
        pendingNotifResult?.success(granted)
        pendingNotifResult = null
    }
}
