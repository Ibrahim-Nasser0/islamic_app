package com.example.islamic_app.alarm

import android.content.Context
import android.content.Intent
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import com.example.islamic_app.R
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AdhanLockPresenter(
    private val context: Context,
    private val onStopAdhan: () -> Unit,
    private val onOpenAppRoute: (route: String) -> Unit,
    private val onDismiss: () -> Unit,
) {
    private lateinit var rosetteView: BreathingRosetteView
    private var bottomControls: AdhanBottomControls? = null
    private var isArabic = true

    fun buildView(intent: Intent): View {
        isArabic = (intent.getStringExtra("languageCode") ?: "ar") == "ar"
        val prayerKey = intent.getStringExtra("prayerKey") ?: "fajr"
        val titleAr = intent.getStringExtra("titleAr") ?: "الفجر"
        val titleEn = intent.getStringExtra("titleEn") ?: "Fajr"
        val timeMillis = intent.getLongExtra("prayerTimeMillis", System.currentTimeMillis())
        val muezzinAr = intent.getStringExtra("muezzinNameAr") ?: "أذان الحرم المكي"
        val muezzinEn = intent.getStringExtra("muezzinNameEn") ?: "Makkah Sanctuary"
        val hijri = intent.getStringExtra(if (isArabic) "hijriDateAr" else "hijriDateEn") ?: ""
        val city = intent.getStringExtra(if (isArabic) "cityAr" else "cityEn") ?: ""
        val initialPlaying = AdhanForegroundService.isPlaying || intent.getBooleanExtra("expectPlaying", false)

        val root = FrameLayout(context).apply {
            layoutDirection = if (isArabic) View.LAYOUT_DIRECTION_RTL else View.LAYOUT_DIRECTION_LTR
        }
        val match = FrameLayout.LayoutParams.MATCH_PARENT
        root.addView(AtmosphericSkyView(context, prayerKey), FrameLayout.LayoutParams(match, match))

        val column = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
        }
        SanctuaryDesignTokens.applyEdgeToEdgePadding(column, horizontalDp = 20f, extraTopDp = 12f, extraBottomDp = 16f)

        val formattedTime = SimpleDateFormat("hh:mm a", Locale.getDefault()).format(Date(timeMillis))
        val pillText = if (isArabic) "الآن موعد صلاة $titleAr  •  $formattedTime" else "$titleEn Prayer Time  •  $formattedTime"
        column.addView(
            SanctuaryUiComponents.buildIconPillBadge(
                context = context,
                label = pillText,
                iconResId = R.drawable.ic_sanctuary_crescent,
                typeface = SanctuaryDesignTokens.amiriBoldTypeface(context),
            ),
        )

        rosetteView = BreathingRosetteView(context, prayerKey).apply { setPlaying(initialPlaying) }
        column.addView(
            rosetteView,
            LinearLayout.LayoutParams(
                SanctuaryDesignTokens.dp(context, 196f),
                SanctuaryDesignTokens.dp(context, 152f),
            ).apply { topMargin = SanctuaryDesignTokens.dp(context, 10f) },
        )

        column.addView(
            TextView(context).apply {
                text = if (isArabic) "صلاة $titleAr" else "$titleEn Prayer"
                textSize = 33f
                typeface = SanctuaryDesignTokens.amiriBoldTypeface(context)
                setTextColor(SanctuaryDesignTokens.IVORY)
                gravity = Gravity.CENTER
                includeFontPadding = false
            },
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply { topMargin = SanctuaryDesignTokens.dp(context, 6f) },
        )

        val contextMeta = listOf(hijri, city, if (isArabic) muezzinAr else muezzinEn)
            .filter { it.isNotBlank() }
            .joinToString("  •  ")
        column.addView(buildFlankedMetaRow(contextMeta))

        val scroll = ScrollView(context).apply {
            isVerticalScrollBarEnabled = false
            addView(AdhanDuaaCard.build(context, isArabic))
        }
        column.addView(scroll, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f))

        bottomControls = AdhanBottomControls(context, isArabic, onStopAdhan, onOpenAppRoute, onDismiss)
        column.addView(
            bottomControls!!.build(initialPlaying),
            LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT)
                .apply { topMargin = SanctuaryDesignTokens.dp(context, 14f) },
        )

        root.addView(column, FrameLayout.LayoutParams(match, match))
        return root
    }

    fun updatePlayingState(playing: Boolean) {
        if (::rosetteView.isInitialized) rosetteView.setPlaying(playing)
        bottomControls?.updatePlaying(playing)
    }

    private fun buildFlankedMetaRow(metaText: String): View {
        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        val lineH = SanctuaryDesignTokens.dp(context, 0.8f).coerceAtLeast(1)
        row.addView(
            View(context).apply { setBackgroundColor(0x45E0B866) },
            LinearLayout.LayoutParams(SanctuaryDesignTokens.dp(context, 22f), lineH),
        )
        row.addView(
            TextView(context).apply {
                text = metaText
                textSize = 12f
                typeface = SanctuaryDesignTokens.amiriRegularTypeface(context)
                setTextColor(SanctuaryDesignTokens.GOLD)
                gravity = Gravity.CENTER
                maxLines = 1
                ellipsize = TextUtils.TruncateAt.END
                setPadding(SanctuaryDesignTokens.dp(context, 10f), 0, SanctuaryDesignTokens.dp(context, 10f), 0)
            },
            LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f),
        )
        row.addView(
            View(context).apply { setBackgroundColor(0x45E0B866) },
            LinearLayout.LayoutParams(SanctuaryDesignTokens.dp(context, 22f), lineH),
        )
        row.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT,
        ).apply {
            topMargin = SanctuaryDesignTokens.dp(context, 6f)
            bottomMargin = SanctuaryDesignTokens.dp(context, 14f)
        }
        return row
    }
}
