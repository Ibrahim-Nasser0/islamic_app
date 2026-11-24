package com.example.islamic_app.alarm

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.graphics.Typeface
import android.text.TextUtils
import android.view.Gravity
import android.view.HapticFeedbackConstants
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import android.widget.Toast
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
    private lateinit var primaryButton: TextView
    private var isArabic = true

    companion object {
        private const val POST_ADHAN_DUAA =
            "اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ القَائِمَةِ، " +
                "آتِ مُحَمَّدًا الوَسِيلَةَ وَالفَضِيلَةَ، " +
                "وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"
        private const val HADITH_REF = "صحيح البخاري • حديث 614"
    }

    fun buildView(intent: Intent): View {
        val lang = intent.getStringExtra("languageCode") ?: "ar"
        isArabic = lang == "ar"
        val prayerKey = intent.getStringExtra("prayerKey") ?: "fajr"
        val titleAr = intent.getStringExtra("titleAr") ?: "الفجر"
        val titleEn = intent.getStringExtra("titleEn") ?: "Fajr"
        val timeMillis = intent.getLongExtra("prayerTimeMillis", System.currentTimeMillis())
        val muezzinAr = intent.getStringExtra("muezzinNameAr") ?: "أذان الحرم المكي"
        val muezzinEn = intent.getStringExtra("muezzinNameEn") ?: "Makkah Sanctuary"
        val muezzinLoc = intent.getStringExtra("muezzinLocation") ?: ""

        val root = FrameLayout(context)
        root.addView(
            AtmosphericSkyView(context, prayerKey),
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
            ),
        )

        val column = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
        }
        SanctuaryDesignTokens.applyEdgeToEdgePadding(column)

        val formattedTime = SimpleDateFormat("hh:mm a", Locale.getDefault()).format(Date(timeMillis))
        val pillText = if (isArabic) "★  الآن موعد صلاة $titleAr  •  $formattedTime" else "★  $titleEn Prayer Time  •  $formattedTime"
        column.addView(buildTopPill(pillText))

        val rosetteSize = SanctuaryDesignTokens.dp(context, 180f)
        rosetteView = BreathingRosetteView(context).apply {
            setPlaying(AdhanForegroundService.isPlaying)
        }
        column.addView(
            rosetteView,
            LinearLayout.LayoutParams(rosetteSize, rosetteSize).apply {
                topMargin = SanctuaryDesignTokens.dp(context, 12f)
            },
        )

        val prayerTitle = TextView(context).apply {
            text = if (isArabic) "صلاة $titleAr" else "$titleEn Prayer"
            textSize = 30f
            typeface = Typeface.create(Typeface.SERIF, Typeface.BOLD)
            setTextColor(SanctuaryDesignTokens.IVORY)
            gravity = Gravity.CENTER
        }
        column.addView(prayerTitle)

        val muezzinDisplay = buildString {
            append(if (isArabic) muezzinAr else muezzinEn)
            if (muezzinLoc.isNotEmpty() && isArabic) append(" • $muezzinLoc")
        }
        val muezzinPill = TextView(context).apply {
            text = muezzinDisplay
            textSize = 13f
            setTextColor(SanctuaryDesignTokens.GOLD)
            gravity = Gravity.CENTER
            maxLines = 1
            ellipsize = TextUtils.TruncateAt.END
            setPadding(
                SanctuaryDesignTokens.dp(context, 14f),
                SanctuaryDesignTokens.dp(context, 6f),
                SanctuaryDesignTokens.dp(context, 14f),
                SanctuaryDesignTokens.dp(context, 6f),
            )
            background = SanctuaryDesignTokens.pillDrawable(
                context,
                SanctuaryDesignTokens.SUBTLE_PILL_BG,
                SanctuaryDesignTokens.CARD_BORDER,
                20f,
            )
        }
        column.addView(
            muezzinPill,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply {
                topMargin = SanctuaryDesignTokens.dp(context, 8f)
                bottomMargin = SanctuaryDesignTokens.dp(context, 14f)
            },
        )

        val scroll = ScrollView(context).apply {
            isVerticalScrollBarEnabled = false
            addView(buildDuaaCard())
        }
        column.addView(
            scroll,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1f,
            ),
        )

        column.addView(
            buildBottomActions(),
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply {
                topMargin = SanctuaryDesignTokens.dp(context, 14f)
            },
        )

        root.addView(
            column,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
            ),
        )
        return root
    }

    fun updatePlayingState(playing: Boolean) {
        if (::rosetteView.isInitialized) rosetteView.setPlaying(playing)
        if (::primaryButton.isInitialized) {
            stylePrimaryButton(playing)
        }
    }

    private fun buildTopPill(textVal: String): TextView = TextView(context).apply {
        text = textVal
        textSize = 13f
        setTextColor(SanctuaryDesignTokens.IVORY)
        typeface = Typeface.DEFAULT_BOLD
        setPadding(
            SanctuaryDesignTokens.dp(context, 16f),
            SanctuaryDesignTokens.dp(context, 8f),
            SanctuaryDesignTokens.dp(context, 16f),
            SanctuaryDesignTokens.dp(context, 8f),
        )
        background = SanctuaryDesignTokens.pillDrawable(
            context,
            SanctuaryDesignTokens.SUBTLE_PILL_BG,
            SanctuaryDesignTokens.CARD_BORDER,
            24f,
        )
    }

    private fun buildDuaaCard(): View {
        val card = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            background = SanctuaryDesignTokens.pillDrawable(
                context,
                SanctuaryDesignTokens.CARD_BG,
                SanctuaryDesignTokens.CARD_BORDER,
                22f,
            )
        }

        val headerRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(
                SanctuaryDesignTokens.dp(context, 16f),
                SanctuaryDesignTokens.dp(context, 10f),
                SanctuaryDesignTokens.dp(context, 16f),
                SanctuaryDesignTokens.dp(context, 10f),
            )
            background = SanctuaryDesignTokens.pillDrawable(
                context,
                SanctuaryDesignTokens.CARD_HEADER_BG,
                0,
                22f,
            )
        }
        val title = TextView(context).apply {
            text = if (isArabic) "دعاء ما بعد الأذان" else "Supplication After Adhan"
            textSize = 13.5f
            typeface = Typeface.DEFAULT_BOLD
            setTextColor(SanctuaryDesignTokens.GOLD)
        }
        headerRow.addView(title, LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f))

        val copyBtn = TextView(context).apply {
            text = if (isArabic) "نسخ" else "Copy"
            textSize = 12f
            setTextColor(SanctuaryDesignTokens.IVORY)
            gravity = Gravity.CENTER
            minHeight = SanctuaryDesignTokens.dp(context, 36f)
            setPadding(
                SanctuaryDesignTokens.dp(context, 12f),
                SanctuaryDesignTokens.dp(context, 4f),
                SanctuaryDesignTokens.dp(context, 12f),
                SanctuaryDesignTokens.dp(context, 4f),
            )
            SanctuaryDesignTokens.applyRipple(
                this,
                SanctuaryDesignTokens.pillDrawable(context, SanctuaryDesignTokens.SUBTLE_PILL_BG, SanctuaryDesignTokens.SUBTLE_BORDER, 16f),
            )
            setOnClickListener {
                it.performHapticFeedback(HapticFeedbackConstants.KEYBOARD_TAP)
                val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                cm.setPrimaryClip(ClipData.newPlainText("duaa", POST_ADHAN_DUAA))
                Toast.makeText(
                    context,
                    if (isArabic) "تم نسخ الدعاء الشريف" else "Supplication copied",
                    Toast.LENGTH_SHORT,
                ).show()
            }
        }
        headerRow.addView(copyBtn)
        card.addView(headerRow)

        val duaaText = TextView(context).apply {
            text = POST_ADHAN_DUAA
            textSize = 17f
            typeface = Typeface.create(Typeface.SERIF, Typeface.NORMAL)
            setTextColor(SanctuaryDesignTokens.IVORY)
            setLineSpacing(0f, 1.55f)
            gravity = Gravity.CENTER
            setPadding(
                SanctuaryDesignTokens.dp(context, 18f),
                SanctuaryDesignTokens.dp(context, 14f),
                SanctuaryDesignTokens.dp(context, 18f),
                SanctuaryDesignTokens.dp(context, 10f),
            )
        }
        card.addView(duaaText)

        val refView = TextView(context).apply {
            text = HADITH_REF
            textSize = 11.5f
            setTextColor(SanctuaryDesignTokens.GOLD)
            gravity = Gravity.CENTER
            setPadding(0, 0, 0, SanctuaryDesignTokens.dp(context, 14f))
        }
        card.addView(refView)
        return card
    }

    private fun buildBottomActions(): View {
        val box = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
        }

        primaryButton = TextView(context).apply {
            gravity = Gravity.CENTER
            textSize = 16f
            typeface = Typeface.DEFAULT_BOLD
            setTextColor(SanctuaryDesignTokens.IVORY)
            minHeight = SanctuaryDesignTokens.dp(context, 56f)
        }
        stylePrimaryButton(AdhanForegroundService.isPlaying)
        box.addView(
            primaryButton,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                SanctuaryDesignTokens.dp(context, 56f),
            ),
        )

        val secondaryRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
        }
        secondaryRow.addView(
            buildSecondaryPill(if (isArabic) "اتجاه القبلة 🧭" else "Qibla 🧭") {
                onOpenAppRoute("/qibla")
            },
            LinearLayout.LayoutParams(0, SanctuaryDesignTokens.dp(context, 48f), 1f).apply {
                marginEnd = SanctuaryDesignTokens.dp(context, 8f)
            },
        )
        secondaryRow.addView(
            buildSecondaryPill(if (isArabic) "فتح زاد المسلم ↗" else "Open App ↗") {
                onOpenAppRoute("/home")
            },
            LinearLayout.LayoutParams(0, SanctuaryDesignTokens.dp(context, 48f), 1f).apply {
                marginStart = SanctuaryDesignTokens.dp(context, 8f)
            },
        )
        box.addView(
            secondaryRow,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply {
                topMargin = SanctuaryDesignTokens.dp(context, 10f)
            },
        )
        return box
    }

    private fun stylePrimaryButton(playing: Boolean) {
        primaryButton.text = when {
            playing && isArabic -> "🔇  إيقاف الأذان"
            playing -> "🔇  Stop Adhan"
            isArabic -> "✓  تم • إغلاق"
            else -> "✓  Done • Dismiss"
        }
        val color = if (playing) SanctuaryDesignTokens.RUBY_STOP else SanctuaryDesignTokens.EMERALD_PRIMARY
        SanctuaryDesignTokens.applyRipple(
            primaryButton,
            SanctuaryDesignTokens.pillDrawable(context, color, 0x40FFFFFF, 28f),
        )
        primaryButton.setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS)
            if (AdhanForegroundService.isPlaying) {
                onStopAdhan()
                updatePlayingState(false)
            } else {
                onDismiss()
            }
        }
    }

    private fun buildSecondaryPill(label: String, onClick: () -> Unit): TextView = TextView(context).apply {
        text = label
        textSize = 13.5f
        typeface = Typeface.DEFAULT_BOLD
        setTextColor(SanctuaryDesignTokens.IVORY)
        gravity = Gravity.CENTER
        SanctuaryDesignTokens.applyRipple(
            this,
            SanctuaryDesignTokens.pillDrawable(context, SanctuaryDesignTokens.SUBTLE_PILL_BG, SanctuaryDesignTokens.SUBTLE_BORDER, 24f),
        )
        setOnClickListener {
            it.performHapticFeedback(HapticFeedbackConstants.KEYBOARD_TAP)
            onClick()
        }
    }
}
