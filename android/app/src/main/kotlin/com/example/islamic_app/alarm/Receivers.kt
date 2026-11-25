package com.example.islamic_app.alarm

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.example.islamic_app.R

class PrayerAlarmReceiver : BroadcastReceiver() {
    companion object {
        const val ACTION_ADHAN = "com.example.islamic_app.action.ALARM_ADHAN"
        const val ACTION_PRE_PRAYER = "com.example.islamic_app.action.ALARM_PRE"
        private const val PRE_CHANNEL_ID = "zad_native_pre_prayer_v1"
        private const val ADHAN_FALLBACK_CHANNEL_PREFIX = "zad_adhan_fallback_"
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_ADHAN -> {
                val serviceIntent = Intent(context, AdhanForegroundService::class.java).apply {
                    action = AdhanForegroundService.ACTION_START
                    putExtras(intent)
                }
                runCatching {
                    ContextCompat.startForegroundService(context, serviceIntent)
                }.onFailure {
                    showFallbackAdhanNotification(context, intent)
                }
            }
            ACTION_PRE_PRAYER -> showPrePrayerNotification(context, intent)
        }
    }

    private fun showFallbackAdhanNotification(context: Context, intent: Intent) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val rawSound = intent.getStringExtra("rawSound") ?: "al_harram_regular"
        val channelId = "$ADHAN_FALLBACK_CHANNEL_PREFIX$rawSound"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            nm.getNotificationChannel(channelId) == null
        ) {
            val soundUri = Uri.parse("android.resource://${context.packageName}/raw/$rawSound")
            val attrs = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()
            val ch = NotificationChannel(channelId, "تنبيه الأذان الاحتياطي", NotificationManager.IMPORTANCE_HIGH).apply {
                setSound(soundUri, attrs)
                enableVibration(true)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            nm.createNotificationChannel(ch)
        }
        val lang = intent.getStringExtra("languageCode") ?: "ar"
        val isAr = lang == "ar"
        val titleAr = intent.getStringExtra("titleAr") ?: "الصلاة"
        val titleEn = intent.getStringExtra("titleEn") ?: "Prayer"
        val notifId = intent.getIntExtra("alarmId", 2001)
        val lockIntent = Intent(context, SanctuaryLockActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(SanctuaryLockActivity.EXTRA_MODE, SanctuaryLockActivity.MODE_ADHAN)
            putExtras(intent)
        }
        val pending = PendingIntent.getActivity(
            context, notifId, lockIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val notif = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.ic_stat_mosque)
            .setContentTitle(if (isAr) "حان الآن موعد صلاة $titleAr" else "It is now time for $titleEn Prayer")
            .setContentText(if (isAr) "الله أكبر • حي على الصلاة" else "Allahu Akbar • Come to Prayer")
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setAutoCancel(true)
            .setContentIntent(pending)
            .setFullScreenIntent(pending, true)
            .build()
        runCatching { nm.notify(notifId, notif) }
    }

    private fun showPrePrayerNotification(context: Context, intent: Intent) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            nm.getNotificationChannel(PRE_CHANNEL_ID) == null
        ) {
            nm.createNotificationChannel(
                NotificationChannel(
                    PRE_CHANNEL_ID,
                    "تنبيه ما قبل الصلاة (5 دقائق)",
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply {
                    enableVibration(true)
                    lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                }
            )
        }
        val lang = intent.getStringExtra("languageCode") ?: "ar"
        val isAr = lang == "ar"
        val titleAr = intent.getStringExtra("titleAr") ?: "الصلاة"
        val titleEn = intent.getStringExtra("titleEn") ?: "Prayer"
        val notifId = intent.getIntExtra("alarmId", 1001)

        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pending = launchIntent?.let {
            PendingIntent.getActivity(
                context,
                notifId,
                it,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }

        val notif = NotificationCompat.Builder(context, PRE_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_mosque)
            .setContentTitle(if (isAr) "اقترب موعد صلاة $titleAr" else "$titleEn Prayer in 5 minutes")
            .setContentText(
                if (isAr) "بقي 5 دقائق لدخول وقت الصلاة • استعد للوضوء والصلاة"
                else "5 minutes remaining • Prepare for Wudu & Prayer"
            )
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(pending)
            .build()
        nm.notify(notifId, notif)
    }
}

class AzkarAlarmReceiver : BroadcastReceiver() {
    companion object {
        const val ACTION_AZKAR_REMINDER = "com.example.islamic_app.action.ALARM_AZKAR"
        const val ACTION_SNOOZE_AZKAR = "com.example.islamic_app.action.SNOOZE_AZKAR"
        private const val AZKAR_CHANNEL_ID = "zad_native_azkar_v1"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val categoryId = intent.getStringExtra("categoryId") ?: "morning"
        val lang = intent.getStringExtra("languageCode") ?: "ar"
        val notifId = intent.getIntExtra("alarmId", 3001)
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (intent.action == ACTION_SNOOZE_AZKAR) {
            nm.cancel(notifId)
            NativeAlarmScheduler.scheduleAzkarSnooze(context, categoryId, lang)
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            nm.getNotificationChannel(AZKAR_CHANNEL_ID) == null
        ) {
            nm.createNotificationChannel(
                NotificationChannel(
                    AZKAR_CHANNEL_ID,
                    "أذكار الصباح والمساء",
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply {
                    enableVibration(true)
                    lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                }
            )
        }

        val openLockAzkar = Intent(context, SanctuaryLockActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(SanctuaryLockActivity.EXTRA_MODE, SanctuaryLockActivity.MODE_AZKAR)
            putExtra("categoryId", categoryId)
            putExtra("languageCode", lang)
        }
        val contentPending = PendingIntent.getActivity(
            context,
            notifId + 100,
            openLockAzkar,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val snoozeIntent = Intent(context, AzkarAlarmReceiver::class.java).apply {
            action = ACTION_SNOOZE_AZKAR
            putExtra("alarmId", notifId)
            putExtra("categoryId", categoryId)
            putExtra("languageCode", lang)
        }
        val snoozePending = PendingIntent.getBroadcast(
            context,
            notifId + 200,
            snoozeIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val isAr = lang == "ar"
        val isMorning = categoryId == "morning"
        val title = when {
            isAr && isMorning -> "أذكار الصباح ☀️"
            isAr -> "أذكار المساء 🌙"
            isMorning -> "Morning Azkar ☀️"
            else -> "Evening Azkar 🌙"
        }
        val body = when {
            isAr && isMorning -> "أصبحنا وأصبح الملك لله • اقرأ أذكارك مباشرة"
            isAr -> "أمسينا وأمسى الملك لله • حصّن نفسك بالذكر"
            else -> "Fortress of the Muslim • Tap to read interactively"
        }

        val notif = NotificationCompat.Builder(context, AZKAR_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_mosque)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setAutoCancel(true)
            .setContentIntent(contentPending)
            .addAction(0, if (isAr) "بدء الأذكار" else "Start Azkar", contentPending)
            .addAction(0, if (isAr) "تأجيل 30 د" else "Snooze 30m", snoozePending)
            .build()
        nm.notify(notifId, notif)
    }
}

class NativeBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        NativeAlarmScheduler.rescheduleFromStorage(context)
    }
}
