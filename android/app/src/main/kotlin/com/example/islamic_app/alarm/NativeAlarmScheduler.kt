package com.example.islamic_app.alarm

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.content.ContextCompat
import org.json.JSONObject

object NativeAlarmScheduler {
    fun syncAndSchedulePrayers(context: Context, payload: JSONObject) {
        NativeScheduleStore.savePrayerPayload(context, payload.toString())
        cancelAllPrayerAlarms(context)

        val adhanEnabled = payload.optBoolean("adhanEnabled", false)
        val preEnabled = payload.optBoolean("preAlertEnabled", false)
        if (!adhanEnabled && !preEnabled) return

        val lockscreenEnabled = payload.optBoolean("lockscreenEnabled", true)
        val lang = payload.optString("languageCode", "ar")
        val muezzinNameAr = payload.optString("muezzinNameAr", "أذان الحرم المكي")
        val muezzinNameEn = payload.optString("muezzinNameEn", "Makkah Sanctuary")
        val muezzinLocation = payload.optString("muezzinLocation", "")
        val entries = payload.optJSONArray("entries") ?: return
        val now = System.currentTimeMillis()
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        for (i in 0 until entries.length()) {
            val item = entries.optJSONObject(i) ?: continue
            val prayerKey = item.optString("prayerKey")
            val titleAr = item.optString("titleAr")
            val titleEn = item.optString("titleEn")
            val rawSound = item.optString("rawSound", "al_harram_regular")

            if (preEnabled) {
                val preId = item.optInt("preId")
                val preAt = item.optLong("preAtMillis")
                if (preAt > now) {
                    val intent = Intent(context, PrayerAlarmReceiver::class.java).apply {
                        action = PrayerAlarmReceiver.ACTION_PRE_PRAYER
                        putExtra("alarmId", preId)
                        putExtra("prayerKey", prayerKey)
                        putExtra("titleAr", titleAr)
                        putExtra("titleEn", titleEn)
                        putExtra("languageCode", lang)
                    }
                    scheduleExactOrFallback(context, alarmManager, preId, preAt, intent, useAlarmClock = false)
                }
            }

            if (adhanEnabled) {
                val adhanId = item.optInt("adhanId")
                val adhanAt = item.optLong("adhanAtMillis")
                if (adhanAt > now) {
                    val intent = Intent(context, PrayerAlarmReceiver::class.java).apply {
                        action = PrayerAlarmReceiver.ACTION_ADHAN
                        putExtra("alarmId", adhanId)
                        putExtra("prayerKey", prayerKey)
                        putExtra("titleAr", titleAr)
                        putExtra("titleEn", titleEn)
                        putExtra("prayerTimeMillis", adhanAt)
                        putExtra("rawSound", rawSound)
                        putExtra("lockscreenEnabled", lockscreenEnabled)
                        putExtra("languageCode", lang)
                        putExtra("muezzinNameAr", muezzinNameAr)
                        putExtra("muezzinNameEn", muezzinNameEn)
                        putExtra("muezzinLocation", muezzinLocation)
                    }
                    scheduleExactOrFallback(context, alarmManager, adhanId, adhanAt, intent, useAlarmClock = true)
                }
            }
        }
    }

    fun syncAndScheduleAzkar(context: Context, payload: JSONObject) {
        NativeScheduleStore.saveAzkarPayload(context, payload.toString())
        cancelAllAzkarAlarms(context)

        if (!payload.optBoolean("enabled", false)) return
        val lang = payload.optString("languageCode", "ar")
        val triggers = payload.optJSONArray("triggers") ?: return
        val now = System.currentTimeMillis()
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        for (i in 0 until triggers.length()) {
            val trigger = triggers.optJSONObject(i) ?: continue
            val id = trigger.optInt("id")
            val categoryId = trigger.optString("categoryId", "morning")
            val atMillis = trigger.optLong("atMillis")
            if (atMillis > now) {
                val intent = Intent(context, AzkarAlarmReceiver::class.java).apply {
                    action = AzkarAlarmReceiver.ACTION_AZKAR_REMINDER
                    putExtra("alarmId", id)
                    putExtra("categoryId", categoryId)
                    putExtra("languageCode", lang)
                }
                scheduleExactOrFallback(context, alarmManager, id, atMillis, intent, useAlarmClock = false)
            }
        }
    }

    fun scheduleAzkarSnooze(context: Context, categoryId: String, lang: String) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val snoozeAt = System.currentTimeMillis() + (30 * 60 * 1000L)
        val intent = Intent(context, AzkarAlarmReceiver::class.java).apply {
            action = AzkarAlarmReceiver.ACTION_AZKAR_REMINDER
            putExtra("alarmId", 3999)
            putExtra("categoryId", categoryId)
            putExtra("languageCode", lang)
        }
        scheduleExactOrFallback(context, alarmManager, 3999, snoozeAt, intent, useAlarmClock = false)
    }

    fun rescheduleFromStorage(context: Context) {
        NativeScheduleStore.loadPrayerPayload(context)?.let {
            syncAndSchedulePrayers(context, it)
        }
        NativeScheduleStore.loadAzkarPayload(context)?.let {
            syncAndScheduleAzkar(context, it)
        }
    }

    fun cancelAllPrayerAlarms(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        for (d in 0 until 7) {
            for (i in 0 until 5) {
                cancelReceiver(context, alarmManager, 1000 + d * 10 + i, PrayerAlarmReceiver::class.java, PrayerAlarmReceiver.ACTION_PRE_PRAYER)
                cancelReceiver(context, alarmManager, 2000 + d * 10 + i, PrayerAlarmReceiver::class.java, PrayerAlarmReceiver.ACTION_ADHAN)
            }
        }
    }

    fun cancelAllAzkarAlarms(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        for (id in 3000..3030) {
            cancelReceiver(context, alarmManager, id, AzkarAlarmReceiver::class.java, AzkarAlarmReceiver.ACTION_AZKAR_REMINDER)
        }
        cancelReceiver(context, alarmManager, 3999, AzkarAlarmReceiver::class.java, AzkarAlarmReceiver.ACTION_AZKAR_REMINDER)
    }

    private fun cancelReceiver(
        context: Context,
        alarmManager: AlarmManager,
        id: Int,
        cls: Class<*>,
        actionStr: String,
    ) {
        val intent = Intent(context, cls).apply { action = actionStr }
        val pi = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
        )
        if (pi != null) {
            alarmManager.cancel(pi)
            pi.cancel()
        }
    }

    private fun scheduleExactOrFallback(
        context: Context,
        alarmManager: AlarmManager,
        requestCode: Int,
        triggerAtMillis: Long,
        intent: Intent,
        useAlarmClock: Boolean,
    ) {
        val pending = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val canExact = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            alarmManager.canScheduleExactAlarms()
        } else {
            true
        }

        if (canExact) {
            try {
                if (useAlarmClock) {
                    val showIntent = PendingIntent.getActivity(
                        context,
                        requestCode + 5000,
                        Intent(context, SanctuaryLockActivity::class.java).apply {
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        },
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                    )
                    alarmManager.setAlarmClock(
                        AlarmManager.AlarmClockInfo(triggerAtMillis, showIntent),
                        pending,
                    )
                } else {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pending,
                    )
                }
                return
            } catch (_: SecurityException) {
                // Fall back to inexact alarm if user revoked permission in OS settings
            }
        }
        alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pending)
    }

    fun checkReliability(context: Context): Map<String, Boolean> {
        val notifGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                context,
                android.Manifest.permission.POST_NOTIFICATIONS,
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val exactAlarms = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            alarmManager.canScheduleExactAlarms()
        } else {
            true
        }
        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val batteryUnrestricted = pm.isIgnoringBatteryOptimizations(context.packageName)

        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val fullScreenIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            nm.canUseFullScreenIntent()
        } else {
            true
        }

        return mapOf(
            "notifications" to notifGranted,
            "exactAlarms" to exactAlarms,
            "batteryUnrestricted" to batteryUnrestricted,
            "fullScreenIntent" to fullScreenIntent,
        )
    }

    fun openBatterySettings(context: Context) {
        val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        runCatching { context.startActivity(intent) }.onFailure {
            openAppDetailsSettings(context)
        }
    }

    fun openNotificationSettings(context: Context) {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
        } else {
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.fromParts("package", context.packageName, null)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
        }
        runCatching { context.startActivity(intent) }.onFailure {
            openAppDetailsSettings(context)
        }
    }

    fun openExactAlarmSettings(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                data = Uri.fromParts("package", context.packageName, null)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            runCatching { context.startActivity(intent) }.onFailure {
                openAppDetailsSettings(context)
            }
        }
    }

    fun openFullScreenIntentSettings(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                data = Uri.fromParts("package", context.packageName, null)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            runCatching { context.startActivity(intent) }.onFailure {
                openAppDetailsSettings(context)
            }
        }
    }

    private fun openAppDetailsSettings(context: Context) {
        val appIntent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.fromParts("package", context.packageName, null)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        runCatching { context.startActivity(appIntent) }
    }
}
