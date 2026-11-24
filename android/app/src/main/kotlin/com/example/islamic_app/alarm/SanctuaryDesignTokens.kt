package com.example.islamic_app.alarm

import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.provider.Settings
import android.util.TypedValue
import android.view.View
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

object SanctuaryDesignTokens {
    const val GOLD = 0xFFE0B866.toInt()
    const val GOLD_SOFT = 0xFFC5A059.toInt()
    const val IVORY = 0xFFFBF7EE.toInt()
    const val TEXT_MUTED = 0xFFD1DDD8.toInt()
    const val RUBY_STOP = 0xFFB91C1C.toInt()
    const val EMERALD_PRIMARY = 0xFF1B5E4F.toInt()
    const val CARD_BG = 0x18FFFFFF
    const val CARD_HEADER_BG = 0x22E0B866
    const val CARD_BORDER = 0x52E0B866
    const val SUBTLE_PILL_BG = 0x1AFFFFFF
    const val SUBTLE_BORDER = 0x33FFFFFF

    fun skyGradient(key: String): IntArray = when (key.lowercase()) {
        "fajr" -> intArrayOf(0xFF07141A.toInt(), 0xFF0D2530.toInt(), 0xFF143B4A.toInt(), 0xFF1F5466.toInt())
        "dhuhr", "morning" -> intArrayOf(0xFF07201B.toInt(), 0xFF0E3830.toInt(), 0xFF145246.toInt(), 0xFF1B6C5C.toInt())
        "asr" -> intArrayOf(0xFF0D1B18.toInt(), 0xFF16322C.toInt(), 0xFF1E463E.toInt(), 0xFF285C51.toInt())
        "maghrib", "evening" -> intArrayOf(0xFF1F1009.toInt(), 0xFF331B10.toInt(), 0xFF4A2718.toInt(), 0xFF6B3822.toInt())
        else -> intArrayOf(0xFF050B14.toInt(), 0xFF0B172A.toInt(), 0xFF11233E.toInt(), 0xFF193257.toInt())
    }

    fun accentGlow(key: String): Int = when (key.lowercase()) {
        "fajr" -> 0xFF64B5F6.toInt()
        "dhuhr", "morning" -> 0xFF4DB6AC.toInt()
        "asr" -> 0xFF81C784.toInt()
        "maghrib", "evening" -> 0xFFFFB74D.toInt()
        else -> 0xFF7986CB.toInt()
    }

    fun dp(context: Context, value: Float): Int = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        value,
        context.resources.displayMetrics,
    ).toInt()

    fun dpF(context: Context, value: Float): Float = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        value,
        context.resources.displayMetrics,
    )

    fun isReduceMotion(context: Context): Boolean {
        val scale = runCatching {
            Settings.Global.getFloat(context.contentResolver, Settings.Global.ANIMATOR_DURATION_SCALE, 1.0f)
        }.getOrDefault(1.0f)
        return scale == 0f
    }

    fun pillDrawable(
        context: Context,
        fillColor: Int,
        strokeColor: Int = Color.TRANSPARENT,
        radiusDp: Float = 24f,
        strokeDp: Float = 1f,
    ): GradientDrawable = GradientDrawable().apply {
        shape = GradientDrawable.RECTANGLE
        cornerRadius = dpF(context, radiusDp)
        setColor(fillColor)
        if (strokeColor != Color.TRANSPARENT) {
            setStroke(dp(context, strokeDp).coerceAtLeast(1), strokeColor)
        }
    }

    fun applyRipple(view: View, base: Drawable, rippleColor: Int = 0x33FFFFFF) {
        view.background = RippleDrawable(ColorStateList.valueOf(rippleColor), base, null)
    }

    fun applyEdgeToEdgePadding(view: View, horizontalDp: Float = 20f, extraTopDp: Float = 16f, extraBottomDp: Float = 20f) {
        val h = dp(view.context, horizontalDp)
        val topExtra = dp(view.context, extraTopDp)
        val bottomExtra = dp(view.context, extraBottomDp)
        view.setPadding(h, dp(view.context, 42f), h, dp(view.context, 24f))
        ViewCompat.setOnApplyWindowInsetsListener(view) { v, insets ->
            val bars = insets.getInsets(WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout())
            v.setPadding(
                h + bars.left,
                bars.top + topExtra,
                h + bars.right,
                bars.bottom + bottomExtra,
            )
            insets
        }
    }
}
