package com.example.islamic_app.alarm

import android.content.Context
import android.view.Gravity
import android.view.HapticFeedbackConstants
import android.view.View
import android.widget.LinearLayout
import com.example.islamic_app.R

/**
 * Ergonomic thumb-zone control dock using centered [SanctuaryButtonView] buttons
 * with tactile press feedback and >= 50dp touch targets.
 */
class AdhanBottomControls(
    private val context: Context,
    private val isArabic: Boolean,
    private val onStopAdhan: () -> Unit,
    private val onOpenAppRoute: (route: String) -> Unit,
    private val onDismiss: () -> Unit,
) {
    private lateinit var primaryButton: SanctuaryButtonView
    private var currentlyPlaying = true

    fun build(initialPlaying: Boolean): View {
        val box = LinearLayout(context).apply { orientation = LinearLayout.VERTICAL }
        primaryButton = SanctuaryButtonView(context)
        updatePlaying(initialPlaying)
        box.addView(
            primaryButton,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                SanctuaryDesignTokens.dp(context, 56f),
            ),
        )

        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
        }
        val boldFont = SanctuaryDesignTokens.amiriBoldTypeface(context)
        val qiblaBtn = SanctuaryButtonView(context).apply {
            configure(
                label = if (isArabic) "اتجاه القبلة" else "Qibla",
                iconResId = R.drawable.ic_sanctuary_qibla,
                iconTint = SanctuaryDesignTokens.GOLD,
                textColor = SanctuaryDesignTokens.IVORY,
                fillColors = intArrayOf(0x20FFFFFF, 0x12FFFFFF),
                borderColor = SanctuaryDesignTokens.SUBTLE_BORDER,
                radiusDp = 25f,
                textSizeSp = 13.5f,
                iconSizeDp = 17f,
                gapDp = 8f,
                typeface = boldFont,
            )
            SanctuaryUiComponents.attachHapticClick(this) { onOpenAppRoute("/qibla") }
        }
        val openBtn = SanctuaryButtonView(context).apply {
            configure(
                label = if (isArabic) "فتح زاد المسلم" else "Open App",
                iconResId = R.drawable.ic_sanctuary_open,
                iconTint = SanctuaryDesignTokens.GOLD,
                textColor = SanctuaryDesignTokens.IVORY,
                fillColors = intArrayOf(0x20FFFFFF, 0x12FFFFFF),
                borderColor = SanctuaryDesignTokens.SUBTLE_BORDER,
                radiusDp = 25f,
                textSizeSp = 13.5f,
                iconSizeDp = 17f,
                gapDp = 8f,
                typeface = boldFont,
            )
            SanctuaryUiComponents.attachHapticClick(this) { onOpenAppRoute("/home") }
        }

        val btnH = SanctuaryDesignTokens.dp(context, 50f)
        row.addView(
            qiblaBtn,
            LinearLayout.LayoutParams(0, btnH, 1f).apply { marginEnd = SanctuaryDesignTokens.dp(context, 6f) },
        )
        row.addView(
            openBtn,
            LinearLayout.LayoutParams(0, btnH, 1f).apply { marginStart = SanctuaryDesignTokens.dp(context, 6f) },
        )
        box.addView(
            row,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply { topMargin = SanctuaryDesignTokens.dp(context, 10f) },
        )
        return box
    }

    fun updatePlaying(playing: Boolean) {
        currentlyPlaying = playing
        if (!::primaryButton.isInitialized) return
        val label = when {
            playing && isArabic -> "إيقاف الأذان"
            playing -> "Stop Adhan"
            isArabic -> "تم • إغلاق"
            else -> "Done • Dismiss"
        }
        primaryButton.configure(
            label = label,
            iconResId = if (playing) R.drawable.ic_sanctuary_stop else R.drawable.ic_sanctuary_check,
            iconTint = SanctuaryDesignTokens.IVORY,
            textColor = SanctuaryDesignTokens.IVORY,
            fillColors = if (playing) intArrayOf(0xFFA42327.toInt(), 0xFF7D1519.toInt())
            else intArrayOf(0xFF1F6E5B.toInt(), 0xFF134B3E.toInt()),
            borderColor = if (playing) 0x70E0B866 else 0x55E0B866,
            radiusDp = 28f,
            textSizeSp = 16f,
            iconSizeDp = 19f,
            gapDp = 9f,
            typeface = SanctuaryDesignTokens.amiriBoldTypeface(context),
        )
        SanctuaryUiComponents.attachHapticClick(primaryButton, HapticFeedbackConstants.LONG_PRESS) {
            if (currentlyPlaying || AdhanForegroundService.isPlaying) {
                onStopAdhan()
                updatePlaying(false)
            } else {
                onDismiss()
            }
        }
    }
}
