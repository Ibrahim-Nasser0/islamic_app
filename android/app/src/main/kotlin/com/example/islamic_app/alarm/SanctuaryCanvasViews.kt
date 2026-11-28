package com.example.islamic_app.alarm

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.view.HapticFeedbackConstants
import android.view.View
import kotlin.math.min

/**
 * Circular Azkar counter ring with gold progress arc and tactile click pulse.
 */
class AzkarCounterRingView(context: Context) : View(context) {
    private var remaining = 1
    private var target = 1
    private var sweepRatio = 0f

    private val trackPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 5.5f)
        color = 0x2CE0B866
    }
    private val progressPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeCap = Paint.Cap.ROUND
        strokeWidth = SanctuaryDesignTokens.dpF(context, 5.5f)
        color = SanctuaryDesignTokens.GOLD
    }
    private val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        color = SanctuaryDesignTokens.EMERALD_PRIMARY
    }
    private val hairlineStroke = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = SanctuaryDesignTokens.dpF(context, 1f)
        color = SanctuaryDesignTokens.CARD_BORDER
    }
    private val countPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = SanctuaryDesignTokens.IVORY
        textAlign = Paint.Align.CENTER
        textSize = SanctuaryDesignTokens.dpF(context, 28f)
        typeface = SanctuaryDesignTokens.amiriBoldTypeface(context)
    }
    private val hintPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = SanctuaryDesignTokens.GOLD
        textAlign = Paint.Align.CENTER
        textSize = SanctuaryDesignTokens.dpF(context, 12f)
        typeface = SanctuaryDesignTokens.amiriRegularTypeface(context)
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
            else HapticFeedbackConstants.KEYBOARD_TAP,
        )
        if (!SanctuaryDesignTokens.isReduceMotion(context)) {
            animate().scaleX(0.94f).scaleY(0.94f).setDuration(80L).withEndAction {
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

        val innerR = radius - SanctuaryDesignTokens.dpF(context, 6f)
        canvas.drawCircle(cx, cy, innerR, fillPaint)
        canvas.drawCircle(cx, cy, innerR, hairlineStroke)
        arcRect.set(cx - radius, cy - radius, cx + radius, cy + radius)
        canvas.drawOval(arcRect, trackPaint)
        canvas.drawArc(arcRect, -90f, 360f * sweepRatio, false, progressPaint)

        canvas.drawText("$remaining", cx, cy + SanctuaryDesignTokens.dpF(context, 4f), countPaint)
        canvas.drawText(labelText, cx, cy + SanctuaryDesignTokens.dpF(context, 24f), hintPaint)
    }
}
