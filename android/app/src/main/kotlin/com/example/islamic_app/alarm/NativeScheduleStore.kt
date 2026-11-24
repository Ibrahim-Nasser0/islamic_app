package com.example.islamic_app.alarm

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

object NativeScheduleStore {
    private const val PREFS_NAME = "zad_native_alarms_prefs"
    private const val KEY_PRAYER_PAYLOAD = "prayer_payload_json"
    private const val KEY_AZKAR_PAYLOAD = "azkar_payload_json"
    private const val KEY_DHIKR_UPDATES = "pending_dhikr_updates_json"
    private const val KEY_PENDING_ROUTE = "pending_launch_route"
    private const val KEY_PENDING_ARGS = "pending_launch_args_json"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun savePrayerPayload(context: Context, json: String) {
        prefs(context).edit().putString(KEY_PRAYER_PAYLOAD, json).apply()
    }

    fun loadPrayerPayload(context: Context): JSONObject? {
        val raw = prefs(context).getString(KEY_PRAYER_PAYLOAD, null) ?: return null
        return runCatching { JSONObject(raw) }.getOrNull()
    }

    fun clearPrayerPayload(context: Context) {
        prefs(context).edit().remove(KEY_PRAYER_PAYLOAD).apply()
    }

    fun saveAzkarPayload(context: Context, json: String) {
        prefs(context).edit().putString(KEY_AZKAR_PAYLOAD, json).apply()
    }

    fun loadAzkarPayload(context: Context): JSONObject? {
        val raw = prefs(context).getString(KEY_AZKAR_PAYLOAD, null) ?: return null
        return runCatching { JSONObject(raw) }.getOrNull()
    }

    fun clearAzkarPayload(context: Context) {
        prefs(context).edit().remove(KEY_AZKAR_PAYLOAD).apply()
    }

    fun recordDhikrUpdate(
        context: Context,
        categoryId: String,
        dhikrId: String,
        remaining: Int,
    ) {
        val existingRaw = prefs(context).getString(KEY_DHIKR_UPDATES, "[]") ?: "[]"
        val array = runCatching { JSONArray(existingRaw) }.getOrElse { JSONArray() }
        val filtered = JSONArray()
        for (i in 0 until array.length()) {
            val obj = array.optJSONObject(i) ?: continue
            if (obj.optString("categoryId") == categoryId &&
                obj.optString("dhikrId") == dhikrId
            ) {
                continue
            }
            filtered.put(obj)
        }
        filtered.put(
            JSONObject().apply {
                put("categoryId", categoryId)
                put("dhikrId", dhikrId)
                put("remaining", remaining)
            }
        )
        prefs(context).edit().putString(KEY_DHIKR_UPDATES, filtered.toString()).apply()
    }

    fun consumeDhikrUpdates(context: Context): List<Map<String, Any>> {
        val raw = prefs(context).getString(KEY_DHIKR_UPDATES, null) ?: return emptyList()
        prefs(context).edit().remove(KEY_DHIKR_UPDATES).apply()
        val array = runCatching { JSONArray(raw) }.getOrNull() ?: return emptyList()
        val list = mutableListOf<Map<String, Any>>()
        for (i in 0 until array.length()) {
            val obj = array.optJSONObject(i) ?: continue
            list.add(
                mapOf(
                    "categoryId" to obj.optString("categoryId"),
                    "dhikrId" to obj.optString("dhikrId"),
                    "remaining" to obj.optInt("remaining"),
                )
            )
        }
        return list
    }

    fun savePendingLaunchRoute(context: Context, route: String, argsJson: String?) {
        prefs(context).edit()
            .putString(KEY_PENDING_ROUTE, route)
            .putString(KEY_PENDING_ARGS, argsJson)
            .apply()
    }

    fun consumePendingLaunchRoute(context: Context): Map<String, Any?>? {
        val p = prefs(context)
        val route = p.getString(KEY_PENDING_ROUTE, null) ?: return null
        val argsRaw = p.getString(KEY_PENDING_ARGS, null)
        p.edit().remove(KEY_PENDING_ROUTE).remove(KEY_PENDING_ARGS).apply()

        val argsMap = if (argsRaw != null) {
            runCatching {
                val obj = JSONObject(argsRaw)
                val map = mutableMapOf<String, Any?>()
                val keys = obj.keys()
                while (keys.hasNext()) {
                    val k = keys.next()
                    map[k] = obj.opt(k)
                }
                map
            }.getOrNull()
        } else {
            null
        }
        return mapOf("route" to route, "args" to argsMap)
    }
}
