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
import android.media.RingtoneManager
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import com.example.islamic_app.R

class AdhanForegroundService : Service() {
    companion object {
        const val ACTION_START = "com.example.islamic_app.action.START_ADHAN"
        const val ACTION_STOP = "com.example.islamic_app.action.STOP_ADHAN"
        const val ACTION_STARTED_BROADCAST = "com.example.islamic_app.action.ADHAN_STARTED"
        const val ACTION_FINISHED_BROADCAST = "com.example.islamic_app.action.ADHAN_FINISHED"
        private const val CHANNEL_ID = "zad_native_adhan_service_v2"
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
            .setSmallIcon(R.drawable.ic_stat_mosque)
            .setContentTitle(notifTitle)
            .setContentText(notifBody)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
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

    private fun resolveRawResId(rawSound: String): Int =
        resources.getIdentifier(rawSound, "raw", packageName)

    private fun resolveFlutterAssetPath(rawSound: String): String = when (rawSound) {
        "abdulbasit_fajr" -> "flutter_assets/assets/audio/abdulbasit/abd-elbaset-fajr.mp3"
        "abdulbasit_regular" -> "flutter_assets/assets/audio/abdulbasit/abd-elbaset-regular.mp3"
        "alafasy_fajr" -> "flutter_assets/assets/audio/alafasy/alafasy-fajr.mp3"
        "alafasy_regular" -> "flutter_assets/assets/audio/alafasy/alafasy-regular.mp3"
        "al_harram_fajr" -> "flutter_assets/assets/audio/harram/al-harram-fajr.mp3"
        else -> "flutter_assets/assets/audio/harram/al-harram-regular.mp3"
    }

    private fun startAdhanAudio(rawSound: String) {
        stopAudioPlayerOnly()
        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
            .build()

        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val focusReq = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                .setAudioAttributes(attributes)
                .setOnAudioFocusChangeListener { change ->
                    when (change) {
                        AudioManager.AUDIOFOCUS_LOSS -> stopPlaybackAndSelf()
                        AudioManager.AUDIOFOCUS_LOSS_TRANSIENT -> runCatching {
                            if (mediaPlayer?.isPlaying == true) mediaPlayer?.pause()
                        }
                        AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK -> runCatching {
                            mediaPlayer?.setVolume(0.25f, 0.25f)
                        }
                        AudioManager.AUDIOFOCUS_GAIN -> runCatching {
                            mediaPlayer?.setVolume(1.0f, 1.0f)
                            if (mediaPlayer?.isPlaying == false) mediaPlayer?.start()
                        }
                    }
                }
                .build()
            audioFocusRequest = focusReq
            audioManager?.requestAudioFocus(focusReq)
        }

        val player = MediaPlayer()
        mediaPlayer = player
        runCatching {
            player.setAudioAttributes(attributes)
            val resId = resolveRawResId(rawSound)
            val rawAfd = if (resId != 0) runCatching { resources.openRawResourceFd(resId) }.getOrNull() else null
            if (rawAfd != null) {
                player.setDataSource(rawAfd.fileDescriptor, rawAfd.startOffset, rawAfd.length)
                rawAfd.close()
            } else {
                val assetAfd = runCatching { assets.openFd(resolveFlutterAssetPath(rawSound)) }.getOrNull()
                if (assetAfd != null) {
                    player.setDataSource(assetAfd.fileDescriptor, assetAfd.startOffset, assetAfd.length)
                    assetAfd.close()
                } else {
                    val alarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                        ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                    player.setDataSource(this, alarmUri)
                }
            }
            player.setOnPreparedListener { mp ->
                isPlaying = true
                mp.setVolume(1.0f, 1.0f)
                mp.start()
                sendBroadcast(Intent(ACTION_STARTED_BROADCAST).setPackage(packageName))
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
