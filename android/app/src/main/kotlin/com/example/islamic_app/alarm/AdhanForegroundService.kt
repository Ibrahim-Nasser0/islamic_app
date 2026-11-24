package com.example.islamic_app.alarm

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class AdhanForegroundService : Service() {
    companion object {
        const val ACTION_START = "com.example.islamic_app.action.START_ADHAN"
        const val ACTION_STOP = "com.example.islamic_app.action.STOP_ADHAN"
        const val ACTION_FINISHED_BROADCAST = "com.example.islamic_app.action.ADHAN_FINISHED"
        private const val CHANNEL_ID = "zad_native_adhan_service_v1"
        private const val NOTIF_ID = 7701

        @Volatile
        var isPlaying: Boolean = false
            private set

        @Volatile
        var activePrayerKey: String = "fajr"
            private set
    }

    private var mediaPlayer: MediaPlayer? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var audioManager: AudioManager? = null
    private var audioFocusRequest: AudioFocusRequest? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopPlaybackAndSelf()
            return START_NOT_STICKY
        }

        val prayerKey = intent?.getStringExtra("prayerKey") ?: "fajr"
        val titleAr = intent?.getStringExtra("titleAr") ?: "الفجر"
        val titleEn = intent?.getStringExtra("titleEn") ?: "Fajr"
        val prayerTimeMillis = intent?.getLongExtra("prayerTimeMillis", System.currentTimeMillis())
            ?: System.currentTimeMillis()
        val rawSound = intent?.getStringExtra("rawSound") ?: "al_harram_regular"
        val lockscreenEnabled = intent?.getBooleanExtra("lockscreenEnabled", true) ?: true
        val lang = intent?.getStringExtra("languageCode") ?: "ar"
        val muezzinNameAr = intent?.getStringExtra("muezzinNameAr") ?: ""
        val muezzinNameEn = intent?.getStringExtra("muezzinNameEn") ?: ""
        val muezzinLocation = intent?.getStringExtra("muezzinLocation") ?: ""

        activePrayerKey = prayerKey
        ensureChannel()

        val lockIntent = Intent(this, SanctuaryLockActivity::class.java).apply {
            this.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(SanctuaryLockActivity.EXTRA_MODE, SanctuaryLockActivity.MODE_ADHAN)
            putExtra("prayerKey", prayerKey)
            putExtra("titleAr", titleAr)
            putExtra("titleEn", titleEn)
            putExtra("prayerTimeMillis", prayerTimeMillis)
            putExtra("languageCode", lang)
            putExtra("muezzinNameAr", muezzinNameAr)
            putExtra("muezzinNameEn", muezzinNameEn)
            putExtra("muezzinLocation", muezzinLocation)
        }

        val contentPending = PendingIntent.getActivity(
            this,
            NOTIF_ID,
            lockIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val stopIntent = Intent(this, AdhanForegroundService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPending = PendingIntent.getService(
            this,
            NOTIF_ID + 1,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val isArabic = lang == "ar"
        val notifTitle = if (isArabic) "حان الآن موعد صلاة $titleAr" else "It is now time for $titleEn Prayer"
        val notifBody = if (isArabic) "الله أكبر • حي على الصلاة • حي على الفلاح" else "Allahu Akbar • Come to Prayer"
        val stopLabel = if (isArabic) "إيقاف الأذان" else "Stop Adhan"

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(resources.getIdentifier("ic_launcher", "mipmap", packageName))
            .setContentTitle(notifTitle)
            .setContentText(notifBody)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setSilent(true)
            .setContentIntent(contentPending)
            .addAction(0, stopLabel, stopPending)

        if (lockscreenEnabled) {
            builder.setFullScreenIntent(contentPending, true)
        }

        val notification = builder.build()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(NOTIF_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
        } else {
            startForeground(NOTIF_ID, notification)
        }

        acquireWakeLock()
        startAdhanAudio(rawSound)
        return START_NOT_STICKY
    }

    private fun ensureChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val existing = nm.getNotificationChannel(CHANNEL_ID)
            if (existing == null) {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    "تشغيل الأذان وشاشة القفل",
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply {
                    description = "قناة مخصصة لصوت الأذان وشاشة القفل"
                    setSound(null, null)
                    enableVibration(true)
                    lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
                }
                nm.createNotificationChannel(channel)
            }
        }
    }

    private fun acquireWakeLock() {
        releaseWakeLock()
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "zad:AdhanServiceWakeLock").apply {
            setReferenceCounted(false)
            acquire(4 * 60 * 1000L)
        }
    }

    private fun releaseWakeLock() {
        runCatching {
            if (wakeLock?.isHeld == true) wakeLock?.release()
        }
        wakeLock = null
    }

    private fun startAdhanAudio(rawSound: String) {
        stopAudioPlayerOnly()
        val resId = resources.getIdentifier(rawSound, "raw", packageName)
            .takeIf { it != 0 }
            ?: resources.getIdentifier("al_harram_regular", "raw", packageName)
        if (resId == 0) return

        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val focusReq = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                .setAudioAttributes(attributes)
                .setOnAudioFocusChangeListener { change ->
                    if (change == AudioManager.AUDIOFOCUS_LOSS ||
                        change == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT
                    ) {
                        stopPlaybackAndSelf()
                    }
                }
                .build()
            audioFocusRequest = focusReq
            audioManager?.requestAudioFocus(focusReq)
        }

        val afd = resources.openRawResourceFd(resId) ?: return
        val player = MediaPlayer()
        mediaPlayer = player
        runCatching {
            player.setAudioAttributes(attributes)
            player.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
            afd.close()
            player.setOnPreparedListener { mp ->
                isPlaying = true
                mp.start()
            }
            player.setOnCompletionListener {
                stopPlaybackAndSelf()
            }
            player.setOnErrorListener { _, _, _ ->
                stopPlaybackAndSelf()
                true
            }
            player.prepareAsync()
        }.onFailure {
            runCatching { afd.close() }
            stopPlaybackAndSelf()
        }
    }

    private fun stopAudioPlayerOnly() {
        runCatching {
            mediaPlayer?.let { mp ->
                if (mp.isPlaying) mp.stop()
                mp.reset()
                mp.release()
            }
        }
        mediaPlayer = null
        isPlaying = false
    }

    private fun stopPlaybackAndSelf() {
        stopAudioPlayerOnly()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioFocusRequest?.let { req ->
                runCatching { audioManager?.abandonAudioFocusRequest(req) }
            }
            audioFocusRequest = null
        }
        releaseWakeLock()
        sendBroadcast(Intent(ACTION_FINISHED_BROADCAST).setPackage(packageName))
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
        stopSelf()
    }

    override fun onDestroy() {
        stopAudioPlayerOnly()
        releaseWakeLock()
        super.onDestroy()
    }
}
