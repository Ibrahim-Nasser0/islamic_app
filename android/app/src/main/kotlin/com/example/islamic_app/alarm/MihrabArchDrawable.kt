package com.example.islamic_app.alarm

import android.content.Context
import android.graphics.Canvas
import android.graphics.ColorFilter
import android.graphics.Paint
import android.graphics.PixelFormat
import android.graphics.Rect
import android.graphics.RectF
import android.graphics.drawable.Drawable

/**
 * Clean museum-grade manuscript frame featuring outer hairline border, subtle inner
 * illuminated double-rule border, and crisp gold L-corners inside bounds (never clipped).
 */
class MihrabArchDrawable(
    context: Context,
    fillColor: Int = SanctuaryDesignTokens.CARD_BG,
    borderColor: Int = SanctuaryDesignTokens.CARD_BORDER,
    private val radiusDp: Float = 22f,
) : Drawable() {
    private val cornerPx = SanctuaryDesignTokens.dpF(context, radiusDp)
    private val innerRuleInset = SanctuaryDesignTokens.dpF(context, 4.5f)
    private val innerCornerPx = (cornerPx - innerRuleInset).coerceAtLeast(8f)
    private val cornerInset = SanctuaryDesignTokens.dpF(context, 10.5f)
    private val cornerArm = SanctuaryDesignTokens.dpF(context, 11f)

    private val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = fillColor
    }
    private val outerStrokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 1f)
        color = borderColor
    }
    private val innerStrokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 0.7f)
        color = 0x26E0B866
    }
    private val cornerPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 1.3f)
        strokeCap = Paint.Cap.ROUND
        color = 0x7AE0B866
    }
    private val dotPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = 0x8CE0B866.toInt()
    }

    private val outerRect = RectF()
    private val innerRect = RectF()

    override fun onBoundsChange(bounds: Rect) {
        super.onBoundsChange(bounds)
        val pad = outerStrokePaint.strokeWidth / 2f
        outerRect.set(bounds.left + pad, bounds.top + pad, bounds.right - pad, bounds.bottom - pad)
        innerRect.set(
            bounds.left + innerRuleInset,
            bounds.top + innerRuleInset,
            bounds.right - innerRuleInset,
            bounds.bottom - innerRuleInset,
        )
    }

    override fun draw(canvas: Canvas) {
        canvas.drawRoundRect(outerRect, cornerPx, cornerPx, fillPaint)
        canvas.drawRoundRect(outerRect, cornerPx, cornerPx, outerStrokePaint)
        canvas.drawRoundRect(innerRect, innerCornerPx, innerCornerPx, innerStrokePaint)

        drawCornerBracket(canvas, outerRect.left + cornerInset, outerRect.top + cornerInset, 1f, 1f)
        drawCornerBracket(canvas, outerRect.right - cornerInset, outerRect.top + cornerInset, -1f, 1f)
        drawCornerBracket(canvas, outerRect.left + cornerInset, outerRect.bottom - cornerInset, 1f, -1f)
        drawCornerBracket(canvas, outerRect.right - cornerInset, outerRect.bottom - cornerInset, -1f, -1f)
    }

    private fun drawCornerBracket(canvas: Canvas, x: Float, y: Float, dx: Float, dy: Float) {
        canvas.drawLine(x, y, x + cornerArm * dx, y, cornerPaint)
        canvas.drawLine(x, y, x, y + cornerArm * dy, cornerPaint)
        canvas.drawCircle(x + (cornerArm * 0.34f) * dx, y + (cornerArm * 0.34f) * dy, 1.7f, dotPaint)
    }

    override fun setAlpha(alpha: Int) {
        fillPaint.alpha = alpha
        outerStrokePaint.alpha = alpha
        innerStrokePaint.alpha = alpha
        cornerPaint.alpha = alpha
    }

    override fun setColorFilter(colorFilter: ColorFilter?) {
        fillPaint.colorFilter = colorFilter
        outerStrokePaint.colorFilter = colorFilter
    }

    @Deprecated("Deprecated in Java")
    override fun getOpacity(): Int = PixelFormat.TRANSLUCENT
}
