package com.example.islamic_app.alarm

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

internal data class NativeDhikrModel(
    val id: String,
    val arabicText: String,
    val targetCount: Int,
    var remaining: Int,
    val fadl: String,
    val reference: String,
)

internal object AzkarLockItemsLoader {
    fun load(context: Context, categoryId: String): MutableList<NativeDhikrModel> {
        val items = mutableListOf<NativeDhikrModel>()
        val stored = NativeScheduleStore.loadAzkarPayload(context)
        val key = if (categoryId == "evening") "eveningItems" else "morningItems"
        val arr: JSONArray? = stored?.optJSONArray(key)
        if (arr != null && arr.length() > 0) {
            for (i in 0 until arr.length()) {
                val obj: JSONObject = arr.optJSONObject(i) ?: continue
                val target = obj.optInt("targetCount", 1).coerceAtLeast(1)
                items.add(
                    NativeDhikrModel(
                        id = obj.optString("id", "z_$i"),
                        arabicText = obj.optString("arabicText"),
                        targetCount = target,
                        remaining = target,
                        fadl = obj.optString("fadl"),
                        reference = obj.optString("reference"),
                    ),
                )
            }
        }
        if (items.isEmpty()) {
            items.add(
                NativeDhikrModel(
                    id = "m_1",
                    arabicText = "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
                    targetCount = 3,
                    remaining = 3,
                    fadl = "كلمتان خفيفتان على اللسان ثقيلتان في الميزان",
                    reference = "متفق عليه",
                ),
            )
        }
        return items
    }
}
