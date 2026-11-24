package com.example.islamic_app.alarm

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.RadialGradient
import android.graphics.RectF
import android.graphics.Shader
import android.view.HapticFeedbackConstants
import android.view.View
import android.view.animation.LinearInterpolator
import kotlin.math.cos
import kotlin.math.min
import kotlin.math.sin

class AtmosphericSkyView(
    context: Context,
    private var themeKey: String = "fajr",
) : View(context) {
    private val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val glowPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val patternPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = 0x09FFFFFF
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 1f)
    }

    fun updateThemeKey(key: String) {
        themeKey = key
        configureShaders(width.toFloat(), height.toFloat())
        invalidate()
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        configureShaders(w.toFloat(), h.toFloat())
    }

    private fun configureShaders(w: Float, h: Float) {
        if (w <= 0f || h <= 0f) return
        bgPaint.shader = LinearGradient(
            0f, 0f, 0f, h,
            SanctuaryDesignTokens.skyGradient(themeKey),
            floatArrayOf(0f, 0.35f, 0.72f, 1f),
            Shader.TileMode.CLAMP,
        )
        val glow = SanctuaryDesignTokens.accentGlow(themeKey)
        val glowCenter = Color.argb(54, Color.red(glow), Color.green(glow), Color.blue(glow))
        val glowMid = Color.argb(18, Color.red(glow), Color.green(glow), Color.blue(glow))
        glowPaint.shader = RadialGradient(
            w / 2f, h * 0.14f, w * 0.72f,
            intArrayOf(glowCenter, glowMid, Color.TRANSPARENT),
            floatArrayOf(0f, 0.55f, 1f),
            Shader.TileMode.CLAMP,
        )
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val w = width.toFloat()
        val h = height.toFloat()
        canvas.drawRect(0f, 0f, w, h, bgPaint)
        canvas.drawRect(0f, 0f, w, h * 0.55f, glowPaint)

        val cx = w / 2f
        val cy = h * 0.42f
        val maxR = w * 0.62f
        val step = SanctuaryDesignTokens.dpF(context, 56f)
        var r = SanctuaryDesignTokens.dpF(context, 44f)
        while (r <= maxR) {
            canvas.drawCircle(cx, cy, r, patternPaint)
            r += step
        }
        for (i in 0 until 8) {
            val angle = i * Math.PI / 4.0
            canvas.drawLine(
                cx,
                cy,
                (cx + maxR * cos(angle)).toFloat(),
                (cy + maxR * sin(angle)).toFloat(),
                patternPaint,
            )
        }
    }
}

class BreathingRosetteView(context: Context) : View(context) {
    private var progress = 0f
    private var isPlaying = true
    private var animator: ValueAnimator? = null

    private val ringPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 1.3f)
    }
    private val starStrokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 1.5f)
        color = 0x70E0B866
    }
    private val starFillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = 0x12FFFFFF
    }
    private val medallionPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = 0x26E0B866
    }
    private val medallionStroke = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 1.8f)
        color = SanctuaryDesignTokens.GOLD
    }
    private val emblemPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = SanctuaryDesignTokens.GOLD
    }
    private val rect = RectF()

    init {
        if (!SanctuaryDesignTokens.isReduceMotion(context)) {
            animator = ValueAnimator.ofFloat(0f, 1f).apply {
                duration = 3200L
                repeatCount = ValueAnimator.INFINITE
                interpolator = LinearInterpolator()
                addUpdateListener {
                    progress = it.animatedValue as Float
                    invalidate()
                }
            }
        }
    }

    fun setPlaying(playing: Boolean) {
        isPlaying = playing
        if (playing && !SanctuaryDesignTokens.isReduceMotion(context)) {
            if (animator?.isStarted != true) animator?.start() else animator?.resume()
        } else {
            animator?.pause()
            invalidate()
        }
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        setPlaying(isPlaying)
    }

    override fun onDetachedFromWindow() {
        animator?.cancel()
        super.onDetachedFromWindow()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val cx = width / 2f
        val cy = height / 2f
        val baseSize = min(width, height).toFloat()

        if (isPlaying) {
            for (offset in listOf(0f, 0.33f, 0.66f)) {
                val p = (progress + offset) % 1f
                val radius = (baseSize * 0.27f) + p * (baseSize * 0.22f)
                val alpha = ((1f - p) * 90f).toInt().coerceIn(0, 255)
                ringPaint.color = Color.argb(alpha, 0xE0, 0xB8, 0x66)
                canvas.drawCircle(cx, cy, radius, ringPaint)
            }
        }

        val scale = if (isPlaying) 1f + (sin(progress * 2 * Math.PI) * 0.035).toFloat() else 1f
        val halfBox = baseSize * 0.23f * scale
        val corner = SanctuaryDesignTokens.dpF(context, 14f)

        for (deg in listOf(0f, 45f)) {
            canvas.save()
            canvas.rotate(deg, cx, cy)
            rect.set(cx - halfBox, cy - halfBox, cx + halfBox, cy + halfBox)
            canvas.drawRoundRect(rect, corner, corner, starFillPaint)
            canvas.drawRoundRect(rect, corner, corner, starStrokePaint)
            canvas.restore()
        }

        val innerR = baseSize * 0.145f
        canvas.drawCircle(cx, cy, innerR, medallionPaint)
        canvas.drawCircle(cx, cy, innerR, medallionStroke)

        // Quiet crescent + star motif inside center medallion
        val cresR = innerR * 0.48f
        canvas.drawCircle(cx, cy, cresR, emblemPaint)
        val maskPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = SanctuaryDesignTokens.skyGradient("fajr")[1]
        }
        canvas.drawCircle(cx + cresR * 0.34f, cy - cresR * 0.16f, cresR * 0.84f, maskPaint)
    }
}

class AzkarCounterRingView(context: Context) : View(context) {
    private var remaining = 1
    private var target = 1
    private var sweepRatio = 0f

    private val trackPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 6f)
        color = 0x2AE0B866
    }
    private val progressPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeCap = Paint.Cap.ROUND
        strokeWidth = SanctuaryDesignTokens.dpF(context, 6f)
        color = SanctuaryDesignTokens.GOLD
    }
    private val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = 0xFF1B5E4F.toInt()
    }
    private val countPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = SanctuaryDesignTokens.IVORY
        textAlign = Paint.Align.CENTER
        textSize = SanctuaryDesignTokens.dpF(context, 28f)
        isFakeBoldText = true
    }
    private val hintPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = SanctuaryDesignTokens.GOLD
        textAlign = Paint.Align.CENTER
        textSize = SanctuaryDesignTokens.dpF(context, 12f)
    }
    private val arcRect = RectF()
    private var labelText = "تسبيح"

    init {
        isClickable = true
        isFocusable = true
    }

    fun updateState(remainingCount: Int, targetCount: Int, tapLabel: String) {
        remaining = remainingCount.coerceAtLeast(0)
        target = targetCount.coerceAtLeast(1)
        labelText = tapLabel
        val doneRatio = ((target - remaining).toFloat() / target.toFloat()).coerceIn(0f, 1f)
        sweepRatio = if (remaining == target) 0.04f else doneRatio
        contentDescription = "$tapLabel $remaining / $target"
        invalidate()
    }

    fun animateTapFeedback(isCompletedNow: Boolean) {
        performHapticFeedback(
            if (isCompletedNow) HapticFeedbackConstants.LONG_PRESS
            else HapticFeedbackConstants.KEYBOARD_TAP
        )
        if (!SanctuaryDesignTokens.isReduceMotion(context)) {
            animate().scaleX(0.93f).scaleY(0.93f).setDuration(80L).withEndAction {
                animate().scaleX(1f).scaleY(1f).setDuration(120L).start()
            }.start()
        }
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val cx = width / 2f
        val cy = height / 2f
        val pad = SanctuaryDesignTokens.dpF(context, 10f)
        val radius = min(cx, cy) - pad

        canvas.drawCircle(cx, cy, radius - SanctuaryDesignTokens.dpF(context, 6f), fillPaint)
        arcRect.set(cx - radius, cy - radius, cx + radius, cy + radius)
        canvas.drawOval(arcRect, trackPaint)
        canvas.drawArc(arcRect, -90f, 360f * sweepRatio, false, progressPaint)

        canvas.drawText("$remaining", cx, cy + SanctuaryDesignTokens.dpF(context, 4f), countPaint)
        canvas.drawText(labelText, cx, cy + SanctuaryDesignTokens.dpF(context, 24f), hintPaint)
    }
}
