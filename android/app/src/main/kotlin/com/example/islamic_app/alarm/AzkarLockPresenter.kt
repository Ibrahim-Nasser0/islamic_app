package com.example.islamic_app.alarm

import android.content.Context
import android.content.Intent
import android.graphics.Typeface
import android.view.Gravity
import android.view.HapticFeedbackConstants
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import org.json.JSONArray
import org.json.JSONObject

class AzkarLockPresenter(
    private val context: Context,
    private val onOpenFullAzkar: (categoryId: String) -> Unit,
    private val onDismiss: () -> Unit,
) {
    private data class DhikrModel(
        val id: String,
        val arabicText: String,
        val targetCount: Int,
        var remaining: Int,
        val fadl: String,
        val reference: String,
    )

    private var categoryId = "morning"
    private var isArabic = true
    private var items = mutableListOf<DhikrModel>()
    private var currentIndex = 0

    private lateinit var skyView: AtmosphericSkyView
    private lateinit var topPill: TextView
    private lateinit var progressFill: View
    private lateinit var dhikrTextView: TextView
    private lateinit var fadlTextView: TextView
    private lateinit var counterRing: AzkarCounterRingView

    fun buildView(intent: Intent): View {
        categoryId = intent.getStringExtra("categoryId") ?: "morning"
        isArabic = (intent.getStringExtra("languageCode") ?: "ar") == "ar"
        loadItems()

        val root = FrameLayout(context)
        skyView = AtmosphericSkyView(context, categoryId)
        root.addView(
            skyView,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
            ),
        )

        val column = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
        }
        SanctuaryDesignTokens.applyEdgeToEdgePadding(column)

        topPill = TextView(context).apply {
            textSize = 13.5f
            typeface = Typeface.DEFAULT_BOLD
            setTextColor(SanctuaryDesignTokens.IVORY)
            setPadding(
                SanctuaryDesignTokens.dp(context, 16f),
                SanctuaryDesignTokens.dp(context, 8f),
                SanctuaryDesignTokens.dp(context, 16f),
                SanctuaryDesignTokens.dp(context, 8f),
            )
            background = SanctuaryDesignTokens.pillDrawable(
                context,
                SanctuaryDesignTokens.SUBTLE_PILL_BG,
                SanctuaryDesignTokens.CARD_BORDER,
                24f,
            )
        }
        column.addView(topPill)

        val progressBarContainer = FrameLayout(context).apply {
            background = SanctuaryDesignTokens.pillDrawable(context, 0x22FFFFFF, radiusDp = 4f)
        }
        progressFill = View(context).apply {
            background = SanctuaryDesignTokens.pillDrawable(context, SanctuaryDesignTokens.GOLD, radiusDp = 4f)
        }
        progressBarContainer.addView(
            progressFill,
            FrameLayout.LayoutParams(0, FrameLayout.LayoutParams.MATCH_PARENT),
        )
        column.addView(
            progressBarContainer,
            LinearLayout.LayoutParams(
                SanctuaryDesignTokens.dp(context, 220f),
                SanctuaryDesignTokens.dp(context, 4f),
            ).apply {
                topMargin = SanctuaryDesignTokens.dp(context, 12f)
                bottomMargin = SanctuaryDesignTokens.dp(context, 16f)
            },
        )

        val card = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(
                SanctuaryDesignTokens.dp(context, 18f),
                SanctuaryDesignTokens.dp(context, 18f),
                SanctuaryDesignTokens.dp(context, 18f),
                SanctuaryDesignTokens.dp(context, 18f),
            )
            background = SanctuaryDesignTokens.pillDrawable(
                context,
                SanctuaryDesignTokens.CARD_BG,
                SanctuaryDesignTokens.CARD_BORDER,
                24f,
            )
        }
        dhikrTextView = TextView(context).apply {
            textSize = 19f
            typeface = Typeface.create(Typeface.SERIF, Typeface.NORMAL)
            setTextColor(SanctuaryDesignTokens.IVORY)
            setLineSpacing(0f, 1.6f)
            gravity = Gravity.CENTER
        }
        fadlTextView = TextView(context).apply {
            textSize = 12.5f
            setTextColor(SanctuaryDesignTokens.GOLD)
            gravity = Gravity.CENTER
            setPadding(0, SanctuaryDesignTokens.dp(context, 14f), 0, 0)
        }
        val scroll = ScrollView(context).apply {
            isVerticalScrollBarEnabled = false
            addView(LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                addView(dhikrTextView)
                addView(fadlTextView)
            })
        }
        card.addView(scroll)
        column.addView(card, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f))

        counterRing = AzkarCounterRingView(context).apply {
            setOnClickListener { handleCounterTap() }
        }
        val ringSize = SanctuaryDesignTokens.dp(context, 124f)
        column.addView(
            counterRing,
            LinearLayout.LayoutParams(ringSize, ringSize).apply {
                topMargin = SanctuaryDesignTokens.dp(context, 16f)
                bottomMargin = SanctuaryDesignTokens.dp(context, 12f)
            },
        )

        column.addView(buildFooterNav())
        root.addView(
            column,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
            ),
        )
        bindCurrentItem()
        return root
    }

    private fun buildFooterNav(): View {
        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
        }
        row.addView(
            pillButton(if (isArabic) "السابق" else "Prev") {
                if (currentIndex > 0) {
                    currentIndex--
                    bindCurrentItem()
                }
            },
            LinearLayout.LayoutParams(0, SanctuaryDesignTokens.dp(context, 48f), 1f).apply {
                marginEnd = SanctuaryDesignTokens.dp(context, 6f)
            },
        )
        row.addView(
            pillButton(if (isArabic) "كل الأذكار ↗" else "Full Azkar ↗", SanctuaryDesignTokens.EMERALD_PRIMARY) {
                onOpenFullAzkar(categoryId)
            },
            LinearLayout.LayoutParams(0, SanctuaryDesignTokens.dp(context, 48f), 1.4f).apply {
                marginStart = SanctuaryDesignTokens.dp(context, 4f)
                marginEnd = SanctuaryDesignTokens.dp(context, 4f)
            },
        )
        row.addView(
            pillButton(if (isArabic) "إغلاق" else "Close") {
                onDismiss()
            },
            LinearLayout.LayoutParams(0, SanctuaryDesignTokens.dp(context, 48f), 1f).apply {
                marginStart = SanctuaryDesignTokens.dp(context, 6f)
            },
        )
        return row
    }

    private fun pillButton(label: String, fill: Int = SanctuaryDesignTokens.SUBTLE_PILL_BG, onClick: () -> Unit): TextView =
        TextView(context).apply {
            text = label
            textSize = 13f
            typeface = Typeface.DEFAULT_BOLD
            setTextColor(SanctuaryDesignTokens.IVORY)
            gravity = Gravity.CENTER
            SanctuaryDesignTokens.applyRipple(
                this,
                SanctuaryDesignTokens.pillDrawable(context, fill, SanctuaryDesignTokens.SUBTLE_BORDER, 24f),
            )
            setOnClickListener {
                it.performHapticFeedback(HapticFeedbackConstants.KEYBOARD_TAP)
                onClick()
            }
        }

    private fun handleCounterTap() {
        val item = items.getOrNull(currentIndex) ?: return
        if (item.remaining > 0) {
            item.remaining -= 1
            NativeScheduleStore.recordDhikrUpdate(context, categoryId, item.id, item.remaining)
        }
        val finishedItem = item.remaining == 0
        counterRing.animateTapFeedback(finishedItem)
        bindCurrentItem()
        if (finishedItem && currentIndex < items.lastIndex) {
            counterRing.postDelayed({
                currentIndex++
                bindCurrentItem()
            }, 260L)
        }
    }

    private fun bindCurrentItem() {
        val total = items.size.coerceAtLeast(1)
        val catTitle = when {
            isArabic && categoryId == "morning" -> "أذكار الصباح ☀️"
            isArabic -> "أذكار المساء 🌙"
            categoryId == "morning" -> "Morning Azkar ☀️"
            else -> "Evening Azkar 🌙"
        }
        topPill.text = "$catTitle  •  ${currentIndex + 1} / $total"

        val ratio = ((currentIndex + 1).toFloat() / total.toFloat()).coerceIn(0f, 1f)
        progressFill.layoutParams = (progressFill.layoutParams as FrameLayout.LayoutParams).apply {
            width = (SanctuaryDesignTokens.dp(context, 220f) * ratio).toInt()
        }

        val item = items.getOrNull(currentIndex) ?: return
        dhikrTextView.text = item.arabicText
        fadlTextView.text = "${item.fadl}\n[ ${item.reference} ]"
        val tapLabel = if (item.remaining == 0) (if (isArabic) "أتممت ✓" else "Done ✓")
        else (if (isArabic) "اضغط للذكر" else "Tap")
        counterRing.updateState(item.remaining, item.targetCount, tapLabel)
    }

    private fun loadItems() {
        items.clear()
        val stored = NativeScheduleStore.loadAzkarPayload(context)
        val key = if (categoryId == "evening") "eveningItems" else "morningItems"
        val arr: JSONArray? = stored?.optJSONArray(key)
        if (arr != null && arr.length() > 0) {
            for (i in 0 until arr.length()) {
                val obj: JSONObject = arr.optJSONObject(i) ?: continue
                val target = obj.optInt("targetCount", 1).coerceAtLeast(1)
                items.add(
                    DhikrModel(
                        id = obj.optString("id", "z_$i"),
                        arabicText = obj.optString("arabicText"),
                        targetCount = target,
                        remaining = target,
                        fadl = obj.optString("fadl"),
                        reference = obj.optString("reference"),
                    )
                )
            }
        }
        if (items.isEmpty()) {
            items.add(
                DhikrModel(
                    id = "m_1",
                    arabicText = "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
                    targetCount = 3,
                    remaining = 3,
                    fadl = "كلمتان خفيفتان على اللسان ثقيلتان في الميزان",
                    reference = "متفق عليه",
                )
            )
        }
    }
}
