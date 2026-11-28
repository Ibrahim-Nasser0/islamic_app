package com.example.islamic_app.alarm

import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.provider.Settings
import android.util.Log
import android.util.TypedValue
import android.view.View
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.drawable.DrawableCompat
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.islamic_app.R

object SanctuaryDesignTokens {
    private const val TAG = "SanctuaryDesignTokens"

    const val GOLD = 0xFFE0B866.toInt()
    const val GOLD_SOFT = 0xFFC5A059.toInt()
    const val IVORY = 0xFFFBF7EE.toInt()
    const val TEXT_MUTED = 0xFFD1DDD8.toInt()
    const val RUBY_STOP = 0xFF9F1D20.toInt()
    const val EMERALD_PRIMARY = 0xFF1B5E4F.toInt()
    const val CARD_BG = 0x16FFFFFF
    const val CARD_HEADER_BG = 0x20E0B866
    const val CARD_BORDER = 0x52E0B866
    const val SUBTLE_PILL_BG = 0x1AFFFFFF
    const val SUBTLE_BORDER = 0x38FFFFFF

    @Volatile
    private var cachedAmiriRegular: Typeface? = null

    @Volatile
    private var cachedAmiriBold: Typeface? = null

    fun amiriRegularTypeface(context: Context): Typeface {
        cachedAmiriRegular?.let { return it }
        return loadFontSafe(context, R.font.amiri_regular, Typeface.SERIF).also {
            cachedAmiriRegular = it
        }
    }

    fun amiriBoldTypeface(context: Context): Typeface {
        cachedAmiriBold?.let { return it }
        return loadFontSafe(
            context,
            R.font.amiri_bold,
            Typeface.create(Typeface.SERIF, Typeface.BOLD),
        ).also {
            cachedAmiriBold = it
        }
    }

    private fun loadFontSafe(context: Context, fontRes: Int, fallback: Typeface): Typeface {
        return try {
            ResourcesCompat.getFont(context, fontRes) ?: fallback
        } catch (e: Exception) {
            Log.w(TAG, "Failed loading native font resource $fontRes, using fallback serif.", e)
            fallback
        }
    }

    fun skyGradient(key: String): IntArray = when (key.lowercase()) {
        "fajr" -> intArrayOf(0xFF061119.toInt(), 0xFF0C2430.toInt(), 0xFF133A4B.toInt(), 0xFF1B4D61.toInt())
        "dhuhr", "morning" -> intArrayOf(0xFF061B17.toInt(), 0xFF0D332B.toInt(), 0xFF134B3F.toInt(), 0xFF196152.toInt())
        "asr" -> intArrayOf(0xFF0C1815.toInt(), 0xFF152E28.toInt(), 0xFF1D4139.toInt(), 0xFF265349.toInt())
        "maghrib", "evening" -> intArrayOf(0xFF1A0D07.toInt(), 0xFF2E170D.toInt(), 0xFF472415.toInt(), 0xFF62331D.toInt())
        else -> intArrayOf(0xFF050A14.toInt(), 0xFF0A1527.toInt(), 0xFF10213B.toInt(), 0xFF172E52.toInt())
    }

    fun accentGlow(key: String): Int = when (key.lowercase()) {
        "fajr" -> 0xFF5CA4D6.toInt()
        "dhuhr", "morning" -> 0xFF489E94.toInt()
        "asr" -> 0xFF73B076.toInt()
        "maghrib", "evening" -> 0xFFD99A4E.toInt()
        else -> 0xFF6B79B8.toInt()
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
        return try {
            Settings.Global.getFloat(
                context.contentResolver,
                Settings.Global.ANIMATOR_DURATION_SCALE,
                1.0f,
            ) == 0f
        } catch (e: Exception) {
            Log.w(TAG, "Unable to read animator scale setting.", e)
            false
        }
    }

    fun tintedIcon(context: Context, resId: Int, color: Int, sizeDp: Float = 18f): Drawable? {
        val raw = ResourcesCompat.getDrawable(context.resources, resId, context.theme) ?: return null
        val wrapped = DrawableCompat.wrap(raw.mutate())
        DrawableCompat.setTint(wrapped, color)
        val px = dp(context, sizeDp)
        wrapped.setBounds(0, 0, px, px)
        return wrapped
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

    fun applyRipple(view: View, base: Drawable, rippleColor: Int = 0x2EFFFFFF) {
        view.background = RippleDrawable(ColorStateList.valueOf(rippleColor), base, null)
    }

    fun applyEdgeToEdgePadding(
        view: View,
        horizontalDp: Float = 20f,
        extraTopDp: Float = 14f,
        extraBottomDp: Float = 18f,
    ) {
        val h = dp(view.context, horizontalDp)
        val topExtra = dp(view.context, extraTopDp)
        val bottomExtra = dp(view.context, extraBottomDp)
        view.setPadding(h, dp(view.context, 42f), h, dp(view.context, 24f))
        ViewCompat.setOnApplyWindowInsetsListener(view) { v, insets ->
            val bars = insets.getInsets(
                WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout(),
            )
            v.setPadding(h + bars.left, bars.top + topExtra, h + bars.right, bars.bottom + bottomExtra)
            insets
        }
    }
}
