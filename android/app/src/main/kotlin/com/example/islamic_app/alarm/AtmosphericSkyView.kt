package com.example.islamic_app.alarm

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RadialGradient
import android.graphics.Shader
import android.view.View
import kotlin.math.cos
import kotlin.math.sin

/**
 * Renders an atmospheric Islamic sky backdrop with precomputed Girih octagrams,
 * soft zenith light, serene bottom dark scrim for AAA legibility, and mosque silhouette.
 */
class AtmosphericSkyView(
    context: Context,
    private var themeKey: String = "fajr",
) : View(context) {
    private val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val horizonGlowPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val bottomScrimPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val girihPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = 0x0AFFFFFF
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 0.8f)
    }
    private val silhouettePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = 0x2A000000
        style = Paint.Style.FILL
    }
    private val silhouetteGoldRim = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = 0x26E0B866
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 0.85f)
    }

    private val girihPath = Path()
    private val silhouettePath = Path()

    fun updateThemeKey(key: String) {
        themeKey = key
        configureShaders(width.toFloat(), height.toFloat())
        invalidate()
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        val wf = w.toFloat()
        val hf = h.toFloat()
        configureShaders(wf, hf)
        rebuildGirihPath(wf, hf)
        rebuildSilhouettePath(wf, hf)
    }

    private fun configureShaders(w: Float, h: Float) {
        if (w <= 0f || h <= 0f) return
        bgPaint.shader = LinearGradient(
            0f, 0f, 0f, h,
            SanctuaryDesignTokens.skyGradient(themeKey),
            floatArrayOf(0f, 0.34f, 0.72f, 1f),
            Shader.TileMode.CLAMP,
        )
        val accent = SanctuaryDesignTokens.accentGlow(themeKey)
        horizonGlowPaint.shader = RadialGradient(
            w / 2f, h * 0.16f, w * 0.65f,
            intArrayOf(
                Color.argb(34, Color.red(accent), Color.green(accent), Color.blue(accent)),
                Color.argb(10, Color.red(accent), Color.green(accent), Color.blue(accent)),
                Color.TRANSPARENT,
            ),
            floatArrayOf(0f, 0.55f, 1f),
            Shader.TileMode.CLAMP,
        )
        bottomScrimPaint.shader = LinearGradient(
            0f, h * 0.65f, 0f, h,
            intArrayOf(Color.TRANSPARENT, 0x4A000000),
            floatArrayOf(0f, 1f),
            Shader.TileMode.CLAMP,
        )
    }

    private fun rebuildGirihPath(w: Float, h: Float) {
        girihPath.reset()
        if (w <= 0f || h <= 0f) return
        val cell = SanctuaryDesignTokens.dpF(context, 96f)
        val r = cell * 0.32f
        var y = cell * 0.35f
        var row = 0
        while (y < h + cell) {
            var x = if (row % 2 == 0) cell * 0.4f else cell * 0.9f
            while (x < w + cell) {
                addRubElHizbToPath(girihPath, x, y, r)
                x += cell
            }
            y += cell * 0.86f
            row++
        }
    }

    private fun addRubElHizbToPath(path: Path, cx: Float, cy: Float, r: Float) {
        for (offsetDeg in listOf(0.0, 45.0)) {
            for (i in 0 until 4) {
                val angle = Math.toRadians(offsetDeg + i * 90.0 + 45.0)
                val px = (cx + r * cos(angle)).toFloat()
                val py = (cy + r * sin(angle)).toFloat()
                if (i == 0) path.moveTo(px, py) else path.lineTo(px, py)
            }
            path.close()
        }
    }

    private fun rebuildSilhouettePath(w: Float, h: Float) {
        silhouettePath.reset()
        if (w <= 0f || h <= 0f) return
        val baseY = h * 0.92f
        val leftX = w * 0.11f
        val rightX = w * 0.89f
        val mW = w * 0.022f
        val mH = h * 0.08f
        val domeX = w * 0.50f
        val domeR = w * 0.15f

        silhouettePath.moveTo(0f, h)
        silhouettePath.lineTo(0f, baseY)
        silhouettePath.lineTo(leftX - mW, baseY)
        silhouettePath.lineTo(leftX - mW * 0.68f, baseY - mH)
        silhouettePath.lineTo(leftX, baseY - mH - w * 0.03f)
        silhouettePath.lineTo(leftX + mW * 0.68f, baseY - mH)
        silhouettePath.lineTo(leftX + mW, baseY)
        silhouettePath.lineTo(domeX - domeR, baseY)
        silhouettePath.cubicTo(
            domeX - domeR, baseY - domeR * 0.56f,
            domeX - domeR * 0.34f, baseY - domeR * 0.86f,
            domeX, baseY - domeR * 0.92f,
        )
        silhouettePath.cubicTo(
            domeX + domeR * 0.34f, baseY - domeR * 0.86f,
            domeX + domeR, baseY - domeR * 0.56f,
            domeX + domeR, baseY,
        )
        silhouettePath.lineTo(rightX - mW, baseY)
        silhouettePath.lineTo(rightX - mW * 0.68f, baseY - mH)
        silhouettePath.lineTo(rightX, baseY - mH - w * 0.03f)
        silhouettePath.lineTo(rightX + mW * 0.68f, baseY - mH)
        silhouettePath.lineTo(rightX + mW, baseY)
        silhouettePath.lineTo(w, baseY)
        silhouettePath.lineTo(w, h)
        silhouettePath.close()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val w = width.toFloat()
        val h = height.toFloat()
        canvas.drawRect(0f, 0f, w, h, bgPaint)
        canvas.drawRect(0f, 0f, w, h * 0.56f, horizonGlowPaint)
        canvas.drawPath(girihPath, girihPaint)
        canvas.drawRect(0f, h * 0.65f, w, h, bottomScrimPaint)
        canvas.drawPath(silhouettePath, silhouettePaint)
        canvas.drawPath(silhouettePath, silhouetteGoldRim)
    }
}
