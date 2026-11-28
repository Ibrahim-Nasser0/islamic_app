package com.example.islamic_app.alarm

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.view.Gravity
import android.view.HapticFeedbackConstants
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import com.example.islamic_app.R

/**
 * Illuminated Manuscript Duaa folio card with flush top header, hairline divider,
 * centered copy button with vector icon, and Sahih Al-Bukhari source attribution.
 */
object AdhanDuaaCard {
    private const val POST_ADHAN_DUAA =
        "اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ القَائِمَةِ، " +
            "آتِ مُحَمَّدًا الوَسِيلَةَ وَالفَضِيلَةَ، " +
            "وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ"
    private const val HADITH_REF = "❖  صحيح البخاري • حديث 614  ❖"

    fun build(context: Context, isArabic: Boolean): View {
        val borderInset = SanctuaryDesignTokens.dp(context, 1f).coerceAtLeast(1)
        val card = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            background = MihrabArchDrawable(context)
            setPadding(borderInset, borderInset, borderInset, borderInset)
        }

        val headerRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(
                SanctuaryDesignTokens.dp(context, 16f),
                SanctuaryDesignTokens.dp(context, 10f),
                SanctuaryDesignTokens.dp(context, 14f),
                SanctuaryDesignTokens.dp(context, 10f),
            )
            background = SanctuaryUiComponents.topRoundedHeaderDrawable(
                context,
                SanctuaryDesignTokens.CARD_HEADER_BG,
                radiusDp = 21f,
            )
        }
        val iconPx = SanctuaryDesignTokens.dp(context, 15f)
        headerRow.addView(
            ImageView(context).apply {
                scaleType = ImageView.ScaleType.FIT_CENTER
                setImageDrawable(
                    SanctuaryDesignTokens.tintedIcon(context, R.drawable.ic_sanctuary_crescent, SanctuaryDesignTokens.GOLD, 15f),
                )
            },
            LinearLayout.LayoutParams(iconPx, iconPx).apply {
                marginEnd = SanctuaryDesignTokens.dp(context, 8f)
            },
        )
        headerRow.addView(
            TextView(context).apply {
                text = if (isArabic) "دعاء ما بعد الأذان" else "Supplication After Adhan"
                textSize = 14f
                typeface = SanctuaryDesignTokens.amiriBoldTypeface(context)
                setTextColor(SanctuaryDesignTokens.GOLD)
                includeFontPadding = false
            },
            LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f),
        )

        val copyBtn = SanctuaryButtonView(context).apply {
            configure(
                label = if (isArabic) "نسخ" else "Copy",
                iconResId = R.drawable.ic_sanctuary_copy,
                iconTint = SanctuaryDesignTokens.IVORY,
                textColor = SanctuaryDesignTokens.IVORY,
                fillColors = intArrayOf(0x24FFFFFF, 0x16FFFFFF),
                borderColor = SanctuaryDesignTokens.SUBTLE_BORDER,
                radiusDp = 18f,
                textSizeSp = 12f,
                iconSizeDp = 14f,
                gapDp = 6f,
                horizontalPaddingDp = 12f,
                typeface = SanctuaryDesignTokens.amiriBoldTypeface(context),
            )
            SanctuaryUiComponents.attachHapticClick(this, HapticFeedbackConstants.KEYBOARD_TAP) {
                val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                cm.setPrimaryClip(ClipData.newPlainText("duaa", POST_ADHAN_DUAA))
                Toast.makeText(
                    context,
                    if (isArabic) "تم نسخ الدعاء الشريف" else "Supplication copied",
                    Toast.LENGTH_SHORT,
                ).show()
            }
        }
        headerRow.addView(copyBtn, LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, SanctuaryDesignTokens.dp(context, 36f)))
        card.addView(headerRow)
        card.addView(SanctuaryUiComponents.horizontalDivider(context))

        card.addView(
            TextView(context).apply {
                text = POST_ADHAN_DUAA
                textSize = 19f
                typeface = SanctuaryDesignTokens.amiriRegularTypeface(context)
                setTextColor(SanctuaryDesignTokens.IVORY)
                setLineSpacing(0f, 1.68f)
                gravity = Gravity.CENTER
                setPadding(
                    SanctuaryDesignTokens.dp(context, 20f),
                    SanctuaryDesignTokens.dp(context, 16f),
                    SanctuaryDesignTokens.dp(context, 20f),
                    SanctuaryDesignTokens.dp(context, 10f),
                )
            },
        )
        card.addView(
            TextView(context).apply {
                text = HADITH_REF
                textSize = 11.5f
                typeface = SanctuaryDesignTokens.amiriBoldTypeface(context)
                setTextColor(SanctuaryDesignTokens.GOLD_SOFT)
                gravity = Gravity.CENTER
                setPadding(0, 0, 0, SanctuaryDesignTokens.dp(context, 14f))
            },
        )
        return card
    }
}
