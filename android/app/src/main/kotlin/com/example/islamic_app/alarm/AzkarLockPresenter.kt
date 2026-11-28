package com.example.islamic_app.alarm

import android.content.Context
import android.content.Intent
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import com.example.islamic_app.R

class AzkarLockPresenter(
    private val context: Context,
    private val onOpenFullAzkar: (categoryId: String) -> Unit,
    private val onDismiss: () -> Unit,
) {
    private var categoryId = "morning"
    private var isArabic = true
    private var items = mutableListOf<NativeDhikrModel>()
    private var currentIndex = 0

    private lateinit var topLabelView: TextView
    private lateinit var progressFill: View
    private lateinit var dhikrTextView: TextView
    private lateinit var fadlTextView: TextView
    private lateinit var counterRing: AzkarCounterRingView

    fun buildView(intent: Intent): View {
        categoryId = intent.getStringExtra("categoryId") ?: "morning"
        isArabic = (intent.getStringExtra("languageCode") ?: "ar") == "ar"
        items = AzkarLockItemsLoader.load(context, categoryId)

        val root = FrameLayout(context).apply {
            layoutDirection = if (isArabic) View.LAYOUT_DIRECTION_RTL else View.LAYOUT_DIRECTION_LTR
        }
        val match = FrameLayout.LayoutParams.MATCH_PARENT
        root.addView(AtmosphericSkyView(context, categoryId), FrameLayout.LayoutParams(match, match))

        val column = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
        }
        SanctuaryDesignTokens.applyEdgeToEdgePadding(column)

        val topBadge = SanctuaryUiComponents.buildIconPillBadge(
            context = context,
            label = "",
            iconResId = R.drawable.ic_sanctuary_crescent,
            typeface = SanctuaryDesignTokens.amiriBoldTypeface(context),
        )
        topLabelView = topBadge.getChildAt(2) as TextView
        column.addView(topBadge)
        column.addView(buildProgressTrack())
        column.addView(buildDhikrCard(), LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f))

        counterRing = AzkarCounterRingView(context).apply { setOnClickListener { handleCounterTap() } }
        val ringSize = SanctuaryDesignTokens.dp(context, 124f)
        column.addView(
            counterRing,
            LinearLayout.LayoutParams(ringSize, ringSize).apply {
                topMargin = SanctuaryDesignTokens.dp(context, 16f)
                bottomMargin = SanctuaryDesignTokens.dp(context, 12f)
            },
        )
        column.addView(buildFooterNav())
        root.addView(column, FrameLayout.LayoutParams(match, match))
        bindCurrentItem()
        return root
    }

    private fun buildProgressTrack(): View {
        val bar = FrameLayout(context).apply {
            background = SanctuaryDesignTokens.pillDrawable(
                context, 0x1EFFFFFF, SanctuaryDesignTokens.CARD_BORDER, radiusDp = 4f, strokeDp = 0.6f,
            )
        }
        progressFill = View(context).apply {
            background = SanctuaryDesignTokens.pillDrawable(context, SanctuaryDesignTokens.GOLD, radiusDp = 4f)
        }
        bar.addView(progressFill, FrameLayout.LayoutParams(0, FrameLayout.LayoutParams.MATCH_PARENT))
        bar.layoutParams = LinearLayout.LayoutParams(
            SanctuaryDesignTokens.dp(context, 220f),
            SanctuaryDesignTokens.dp(context, 5f),
        ).apply {
            topMargin = SanctuaryDesignTokens.dp(context, 12f)
            bottomMargin = SanctuaryDesignTokens.dp(context, 16f)
        }
        return bar
    }

    private fun buildDhikrCard(): View {
        val pad = SanctuaryDesignTokens.dp(context, 18f)
        val card = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(pad, SanctuaryDesignTokens.dp(context, 20f), pad, pad)
            background = MihrabArchDrawable(context, radiusDp = 24f)
        }
        dhikrTextView = TextView(context).apply {
            textSize = 19.5f
            typeface = SanctuaryDesignTokens.amiriRegularTypeface(context)
            setTextColor(SanctuaryDesignTokens.IVORY)
            setLineSpacing(0f, 1.65f)
            gravity = Gravity.CENTER
        }
        fadlTextView = TextView(context).apply {
            textSize = 12.5f
            typeface = SanctuaryDesignTokens.amiriBoldTypeface(context)
            setTextColor(SanctuaryDesignTokens.GOLD)
            gravity = Gravity.CENTER
            setPadding(0, SanctuaryDesignTokens.dp(context, 14f), 0, 0)
        }
        card.addView(
            ScrollView(context).apply {
                isVerticalScrollBarEnabled = false
                addView(LinearLayout(context).apply {
                    orientation = LinearLayout.VERTICAL
                    addView(dhikrTextView)
                    addView(fadlTextView)
                })
            },
        )
        return card
    }

    private fun navPill(
        label: String,
        iconRes: Int? = null,
        fills: IntArray = intArrayOf(0x20FFFFFF, 0x12FFFFFF),
        border: Int = SanctuaryDesignTokens.SUBTLE_BORDER,
        onClick: () -> Unit,
    ) = SanctuaryButtonView(context).apply {
        configure(
            label = label, iconResId = iconRes, iconTint = SanctuaryDesignTokens.GOLD,
            fillColors = fills, borderColor = border, radiusDp = 25f, textSizeSp = 13.5f,
            iconSizeDp = 16f, gapDp = 7f, typeface = SanctuaryDesignTokens.amiriBoldTypeface(context),
        )
        SanctuaryUiComponents.attachHapticClick(this, onClick = onClick)
    }

    private fun buildFooterNav(): View {
        val row = LinearLayout(context).apply { orientation = LinearLayout.HORIZONTAL; gravity = Gravity.CENTER }
        val btnH = SanctuaryDesignTokens.dp(context, 50f)
        val prevBtn = navPill(if (isArabic) "السابق" else "Prev") {
            if (currentIndex > 0) {
                currentIndex--
                bindCurrentItem()
            }
        }
        val allBtn = navPill(
            label = if (isArabic) "كل الأذكار" else "Full Azkar", iconRes = R.drawable.ic_sanctuary_open,
            fills = intArrayOf(0xFF1F6E5B.toInt(), 0xFF134B3E.toInt()), border = SanctuaryDesignTokens.CARD_BORDER,
        ) { onOpenFullAzkar(categoryId) }
        val closeBtn = navPill(if (isArabic) "إغلاق" else "Close") { onDismiss() }

        row.addView(prevBtn, LinearLayout.LayoutParams(0, btnH, 1f).apply { marginEnd = SanctuaryDesignTokens.dp(context, 6f) })
        row.addView(allBtn, LinearLayout.LayoutParams(0, btnH, 1.45f).apply {
            marginStart = SanctuaryDesignTokens.dp(context, 4f); marginEnd = SanctuaryDesignTokens.dp(context, 4f)
        })
        row.addView(closeBtn, LinearLayout.LayoutParams(0, btnH, 1f).apply { marginStart = SanctuaryDesignTokens.dp(context, 6f) })
        return row
    }

    private fun handleCounterTap() {
        val item = items.getOrNull(currentIndex) ?: return
        if (item.remaining > 0) {
            item.remaining -= 1
            NativeScheduleStore.recordDhikrUpdate(context, categoryId, item.id, item.remaining)
        }
        val finished = item.remaining == 0
        counterRing.animateTapFeedback(finished)
        bindCurrentItem()
        if (finished && currentIndex < items.lastIndex) {
            counterRing.postDelayed({ currentIndex++; bindCurrentItem() }, 260L)
        }
    }

    private fun bindCurrentItem() {
        val total = items.size.coerceAtLeast(1)
        val catTitle = when {
            isArabic && categoryId == "morning" -> "أذكار الصباح"
            isArabic -> "أذكار المساء"
            categoryId == "morning" -> "Morning Azkar"
            else -> "Evening Azkar"
        }
        topLabelView.text = "$catTitle  •  ${currentIndex + 1} / $total"
        val ratio = ((currentIndex + 1).toFloat() / total.toFloat()).coerceIn(0f, 1f)
        progressFill.layoutParams = (progressFill.layoutParams as FrameLayout.LayoutParams).apply {
            width = (SanctuaryDesignTokens.dp(context, 220f) * ratio).toInt()
        }
        val item = items.getOrNull(currentIndex) ?: return
        dhikrTextView.text = item.arabicText
        fadlTextView.text = "${item.fadl}\n[ ${item.reference} ]"
        counterRing.updateState(
            item.remaining,
            item.targetCount,
            if (item.remaining == 0) (if (isArabic) "أتممت" else "Done") else (if (isArabic) "اضغط للذكر" else "Tap"),
        )
    }
}
