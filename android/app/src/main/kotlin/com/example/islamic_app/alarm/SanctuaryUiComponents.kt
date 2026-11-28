package com.example.islamic_app.alarm

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.view.Gravity
import android.view.HapticFeedbackConstants
import android.view.MotionEvent
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView

/**
 * Centered icon + label pill button & badge container with real LinearLayout
 * centering (immune to TextView compoundDrawable edge-sticking) and tactile press scale.
 */
class SanctuaryButtonView(context: Context) : LinearLayout(context) {
    private val iconView = ImageView(context).apply {
        scaleType = ImageView.ScaleType.FIT_CENTER
        visibility = View.GONE
    }
    private val gapView = View(context).apply { visibility = View.GONE }
    private val labelView = TextView(context).apply {
        includeFontPadding = false
        maxLines = 1
    }

    init {
        orientation = HORIZONTAL
        gravity = Gravity.CENTER
        isClickable = true
        isFocusable = true
        addView(iconView)
        addView(gapView)
        addView(labelView)
        setupTactilePress()
    }

    fun configure(
        label: String,
        iconResId: Int? = null,
        iconTint: Int = SanctuaryDesignTokens.IVORY,
        textColor: Int = SanctuaryDesignTokens.IVORY,
        fillColors: IntArray,
        borderColor: Int,
        radiusDp: Float = 24f,
        textSizeSp: Float = 14f,
        iconSizeDp: Float = 18f,
        gapDp: Float = 8f,
        horizontalPaddingDp: Float = 16f,
        typeface: Typeface = Typeface.DEFAULT_BOLD,
        rippleColor: Int = 0x2EFFFFFF,
    ) {
        val hPad = SanctuaryDesignTokens.dp(context, horizontalPaddingDp)
        setPadding(hPad, 0, hPad, 0)

        labelView.text = label
        labelView.textSize = textSizeSp
        labelView.typeface = typeface
        labelView.setTextColor(textColor)

        if (iconResId != null) {
            val iconPx = SanctuaryDesignTokens.dp(context, iconSizeDp)
            iconView.setImageDrawable(SanctuaryDesignTokens.tintedIcon(context, iconResId, iconTint, iconSizeDp))
            iconView.layoutParams = LayoutParams(iconPx, iconPx)
            iconView.visibility = View.VISIBLE
            gapView.layoutParams = LayoutParams(SanctuaryDesignTokens.dp(context, gapDp), 1)
            gapView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
            gapView.visibility = View.GONE
        }

        val bg = GradientDrawable(
            GradientDrawable.Orientation.TOP_BOTTOM,
            if (fillColors.size >= 2) fillColors else intArrayOf(fillColors[0], fillColors[0]),
        ).apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = SanctuaryDesignTokens.dpF(context, radiusDp)
            setStroke(SanctuaryDesignTokens.dp(context, 1f).coerceAtLeast(1), borderColor)
        }
        background = RippleDrawable(ColorStateList.valueOf(rippleColor), bg, null)
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun setupTactilePress() {
        setOnTouchListener { v, event ->
            if (!SanctuaryDesignTokens.isReduceMotion(context)) {
                when (event.actionMasked) {
                    MotionEvent.ACTION_DOWN ->
                        v.animate().scaleX(0.965f).scaleY(0.965f).setDuration(85L).start()
                    MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL ->
                        v.animate().scaleX(1f).scaleY(1f).setDuration(120L).start()
                }
            }
            false
        }
    }
}

object SanctuaryUiComponents {
    fun buildIconPillBadge(
        context: Context,
        label: String,
        iconResId: Int,
        iconTint: Int = SanctuaryDesignTokens.GOLD,
        textColor: Int = SanctuaryDesignTokens.IVORY,
        fillColor: Int = SanctuaryDesignTokens.SUBTLE_PILL_BG,
        borderColor: Int = SanctuaryDesignTokens.CARD_BORDER,
        iconSizeDp: Float = 15f,
        fontSizeSp: Float = 13f,
        typeface: Typeface = Typeface.DEFAULT_BOLD,
    ): LinearLayout = LinearLayout(context).apply {
        orientation = LinearLayout.HORIZONTAL
        gravity = Gravity.CENTER
        setPadding(
            SanctuaryDesignTokens.dp(context, 14f),
            SanctuaryDesignTokens.dp(context, 6f),
            SanctuaryDesignTokens.dp(context, 14f),
            SanctuaryDesignTokens.dp(context, 6f),
        )
        background = SanctuaryDesignTokens.pillDrawable(context, fillColor, borderColor, 24f)
        val px = SanctuaryDesignTokens.dp(context, iconSizeDp)
        addView(
            ImageView(context).apply {
                scaleType = ImageView.ScaleType.FIT_CENTER
                setImageDrawable(SanctuaryDesignTokens.tintedIcon(context, iconResId, iconTint, iconSizeDp))
            },
            LinearLayout.LayoutParams(px, px),
        )
        addView(View(context), LinearLayout.LayoutParams(SanctuaryDesignTokens.dp(context, 7f), 1))
        addView(
            TextView(context).apply {
                text = label
                textSize = fontSizeSp
                this.typeface = typeface
                setTextColor(textColor)
                includeFontPadding = false
            },
        )
    }

    fun topRoundedHeaderDrawable(context: Context, fillColor: Int, radiusDp: Float = 22f): GradientDrawable {
        val r = SanctuaryDesignTokens.dpF(context, radiusDp)
        return GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadii = floatArrayOf(r, r, r, r, 0f, 0f, 0f, 0f)
            setColor(fillColor)
        }
    }

    fun horizontalDivider(context: Context): View = View(context).apply {
        setBackgroundColor(0x3DE0B866)
        layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            SanctuaryDesignTokens.dp(context, 0.8f).coerceAtLeast(1),
        )
    }

    fun formatMetaLine(hijri: String, city: String): String = when {
        hijri.isNotBlank() && city.isNotBlank() -> "$hijri  •  $city"
        hijri.isNotBlank() -> hijri
        city.isNotBlank() -> city
        else -> ""
    }

    fun attachHapticClick(view: View, haptic: Int = HapticFeedbackConstants.KEYBOARD_TAP, onClick: () -> Unit) {
        view.setOnClickListener {
            it.performHapticFeedback(haptic)
            onClick()
        }
    }
}
