package com.example.islamic_app.alarm

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.view.View
import android.view.animation.LinearInterpolator
import kotlin.math.cos
import kotlin.math.min
import kotlin.math.sin

/**
 * Architectural Mihrab Canopy framing the animated geometric Rub el Hizb octagram
 * medallion with restrained breathing waves and crisp crescent + 8-point star core.
 */
class BreathingRosetteView(
    context: Context,
    private var themeKey: String = "fajr",
) : View(context) {
    private var progress = 0f
    private var isPlaying = true
    private var animator: ValueAnimator? = null

    private fun strokePaint(dpW: Float, col: Int) = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, dpW)
        color = col
    }

    private fun fillPaint(col: Int) = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = col
    }

    private val mihrabStroke = strokePaint(1.25f, 0x5CE0B866)
    private val mihrabInnerStroke = strokePaint(0.7f, 0x2CE0B866)
    private val mihrabFill = fillPaint(0x0CFFFFFF)
    private val ringPaint = strokePaint(1.15f, 0)
    private val starStrokePaint = strokePaint(1.4f, 0x94E0B866.toInt())
    private val innerFiligreePaint = strokePaint(0.85f, 0x4DE0B866)
    private val starFillPaint = fillPaint(0x10FFFFFF)
    private val medallionPaint = fillPaint(0x24E0B866)
    private val medallionStroke = strokePaint(1.5f, SanctuaryDesignTokens.GOLD)
    private val emblemPaint = fillPaint(SanctuaryDesignTokens.GOLD)
    private val maskPaint = fillPaint(SanctuaryDesignTokens.skyGradient(themeKey)[1])

    private val rect = RectF()
    private val starPath = Path()
    private val archOuterPath = Path()
    private val archInnerPath = Path()

    init {
        if (!SanctuaryDesignTokens.isReduceMotion(context)) {
            animator = ValueAnimator.ofFloat(0f, 1f).apply {
                duration = 3600L
                repeatCount = ValueAnimator.INFINITE
                interpolator = LinearInterpolator()
                addUpdateListener {
                    progress = it.animatedValue as Float
                    invalidate()
                }
            }
        }
    }

    fun setThemeKey(key: String) {
        themeKey = key
        maskPaint.color = SanctuaryDesignTokens.skyGradient(key)[1]
        invalidate()
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

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        buildPointedArch(archOuterPath, w / 2f, h * 0.94f, w * 0.43f, h * 0.87f)
        buildPointedArch(archInnerPath, w / 2f, h * 0.94f, w * 0.39f, h * 0.81f)
    }

    private fun buildPointedArch(path: Path, cx: Float, bottomY: Float, halfW: Float, archH: Float) {
        path.reset()
        val apexY = bottomY - archH
        val shoulderY = bottomY - archH * 0.56f
        path.moveTo(cx - halfW, bottomY)
        path.lineTo(cx - halfW, shoulderY)
        path.cubicTo(cx - halfW, apexY + archH * 0.16f, cx - halfW * 0.35f, apexY + archH * 0.06f, cx, apexY)
        path.cubicTo(cx + halfW * 0.35f, apexY + archH * 0.06f, cx + halfW, apexY + archH * 0.16f, cx + halfW, shoulderY)
        path.lineTo(cx + halfW, bottomY)
        path.close()
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
        val w = width.toFloat()
        val h = height.toFloat()
        canvas.drawPath(archOuterPath, mihrabFill)
        canvas.drawPath(archOuterPath, mihrabStroke)
        canvas.drawPath(archInnerPath, mihrabInnerStroke)

        val cx = w / 2f
        val cy = h * 0.56f
        val baseSize = min(w, h).toFloat()
        drawEightPointStar(canvas, cx, h * 0.055f, baseSize * 0.032f)

        if (isPlaying) {
            for (offset in listOf(0f, 0.34f, 0.68f)) {
                val p = (progress + offset) % 1f
                val radius = (baseSize * 0.25f) + p * (baseSize * 0.15f)
                val alpha = ((1f - p) * 58f).toInt().coerceIn(0, 255)
                ringPaint.color = Color.argb(alpha, 0xE0, 0xB8, 0x66)
                canvas.drawCircle(cx, cy, radius, ringPaint)
            }
        }

        val scale = if (isPlaying) 1f + (sin(progress * 2 * Math.PI) * 0.025).toFloat() else 1f
        val outerHalf = baseSize * 0.205f * scale
        val corner = SanctuaryDesignTokens.dpF(context, 9f)
        for (deg in listOf(0f, 45f)) {
            canvas.save()
            canvas.rotate(deg, cx, cy)
            rect.set(cx - outerHalf, cy - outerHalf, cx + outerHalf, cy + outerHalf)
            canvas.drawRoundRect(rect, corner, corner, starFillPaint)
            canvas.drawRoundRect(rect, corner, corner, starStrokePaint)
            val innerHalf = outerHalf * 0.83f
            rect.set(cx - innerHalf, cy - innerHalf, cx + innerHalf, cy + innerHalf)
            canvas.drawRoundRect(rect, corner * 0.7f, corner * 0.7f, innerFiligreePaint)
            canvas.restore()
        }

        val innerR = baseSize * 0.128f
        canvas.drawCircle(cx, cy, innerR, maskPaint)
        canvas.drawCircle(cx, cy, innerR, medallionPaint)
        canvas.drawCircle(cx, cy, innerR, medallionStroke)

        val cresR = innerR * 0.48f
        canvas.drawCircle(cx - cresR * 0.10f, cy, cresR, emblemPaint)
        canvas.drawCircle(cx + cresR * 0.24f, cy - cresR * 0.16f, cresR * 0.82f, maskPaint)
        drawEightPointStar(canvas, cx + innerR * 0.34f, cy - innerR * 0.26f, innerR * 0.16f)
    }

    private fun drawEightPointStar(canvas: Canvas, cx: Float, cy: Float, r: Float) {
        starPath.reset()
        for (i in 0 until 8) {
            val rad = if (i % 2 == 0) r else r * 0.42f
            val angle = i * Math.PI / 4.0
            val px = (cx + rad * cos(angle)).toFloat()
            val py = (cy + rad * sin(angle)).toFloat()
            if (i == 0) starPath.moveTo(px, py) else starPath.lineTo(px, py)
        }
        starPath.close()
        canvas.drawPath(starPath, emblemPaint)
    }
}
