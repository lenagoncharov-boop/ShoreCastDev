// Copy this file to:
//   android/app/src/main/kotlin/<your/package/path>/SeaConditionWidgetProvider.kt
// and make sure the `package` line below matches your app's applicationId
// (see android/app/build.gradle.kts -> defaultConfig.applicationId).
//
// Reads the key/value pairs written by lib/services/widget_service.dart
// (via the home_widget plugin) and renders them into the home-screen
// widget's RemoteViews. All the strings arrive already-formatted (icons,
// units, labels) from Dart — this file just places them.
//
// Each widget instance can have its own "headline" metric, chosen three
// ways, all landing in the same per-widget SharedPreferences entry:
//   1) automatically, the moment the widget is added (android:configure
//      -> WidgetConfigureActivity's spinner)
//   2) later, via the gear icon -> WidgetConfigureActivity again
//   3) fastest: tap directly on one of the four small metric rows on the
//      widget itself, and it instantly swaps into the headline slot (no
//      screen to open at all) — handled entirely in this file via
//      ACTION_SET_HEADLINE, a broadcast this provider sends to itself.
// buildRemoteViews() is the single shared renderer all three paths call,
// so the widget always redraws consistently.

package com.shorecast.shorecast_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider

class SeaConditionWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = buildRemoteViews(context, widgetId, widgetData)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    // Handles the tap-a-metric-row-to-promote-it broadcast (see
    // ACTION_SET_HEADLINE below) in addition to the normal AppWidget
    // lifecycle broadcasts that HomeWidgetProvider/AppWidgetProvider
    // already handle via onReceive -> onUpdate/onDeleted/etc.
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_SET_HEADLINE) {
            val widgetId = intent.getIntExtra(
                AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID
            )
            val metricId = intent.getStringExtra(EXTRA_METRIC_ID)
            if (widgetId != AppWidgetManager.INVALID_APPWIDGET_ID &&
                metricId != null && ALL_METRIC_IDS.contains(metricId)
            ) {
                savePrimaryMetric(context, widgetId, metricId)
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val widgetData = HomeWidgetPlugin.getData(context)
                val views = buildRemoteViews(context, widgetId, widgetData)
                appWidgetManager.updateAppWidget(widgetId, views)
            }
            return
        }
        super.onReceive(context, intent)
    }

    companion object {
        /** The five metrics a user can pick as the widget's headline. Must stay
         *  in sync with WidgetConstants.metricIds in lib/core/constants.dart. */
        val ALL_METRIC_IDS = listOf("wave", "wind", "tide", "air", "water")

        private const val CONFIG_PREFS_NAME = "ShoreCastWidgetConfig"
        private const val PRIMARY_METRIC_KEY_PREFIX = "primary_metric_"

        // Self-addressed broadcast fired when the user taps one of the four
        // small metric rows on the widget, promoting it to headline in place.
        private const val ACTION_SET_HEADLINE = "com.shorecast.shorecast_app.ACTION_SET_HEADLINE"
        private const val EXTRA_METRIC_ID = "metric_id"

        /** Reads the saved headline choice for one widget instance, defaulting
         *  to "wave" for a widget that was never configured (shouldn't normally
         *  happen once android:configure is wired up, but keeps things safe). */
        fun primaryMetricFor(context: Context, widgetId: Int): String {
            val prefs = context.getSharedPreferences(CONFIG_PREFS_NAME, Context.MODE_PRIVATE)
            val saved = prefs.getString(PRIMARY_METRIC_KEY_PREFIX + widgetId, null)
            return if (saved != null && ALL_METRIC_IDS.contains(saved)) saved else "wave"
        }

        fun savePrimaryMetric(context: Context, widgetId: Int, metricId: String) {
            val prefs = context.getSharedPreferences(CONFIG_PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit().putString(PRIMARY_METRIC_KEY_PREFIX + widgetId, metricId).apply()
        }

        /**
         * Builds the RemoteViews for one widget instance, honoring that
         * instance's chosen headline metric. Shared between onUpdate() and
         * WidgetConfigureActivity's "Save" action so a newly-picked headline
         * redraws immediately instead of waiting for the next onUpdate.
         */
        fun buildRemoteViews(context: Context, widgetId: Int, widgetData: SharedPreferences): RemoteViews {
            val headline = primaryMetricFor(context, widgetId)
            val others = ALL_METRIC_IDS.filter { it != headline }

            return RemoteViews(context.packageName, R.layout.sea_condition_widget).apply {
                setTextViewText(
                    R.id.widget_location,
                    widgetData.getString("widget_location_line", "📍 ShoreCast")
                )
                setTextViewText(
                    R.id.widget_headline_value,
                    widgetData.getString("widget_metric_${headline}_value", "--")
                )
                setTextViewText(
                    R.id.widget_headline_subtitle,
                    widgetData.getString("widget_metric_${headline}_subtitle", "--")
                )
                setTextViewText(
                    R.id.widget_rating,
                    widgetData.getString("widget_rating_label", "--")
                )

                // The four metrics NOT chosen as the headline fill the small
                // info grid, in a fixed left-to-right / top-to-bottom order.
                // Each one is individually tappable: tapping a row promotes
                // that metric straight to the headline slot, right there on
                // the home screen, no screen to open.
                val slotIds = intArrayOf(
                    R.id.widget_slot_1, R.id.widget_slot_2, R.id.widget_slot_3, R.id.widget_slot_4
                )
                slotIds.forEachIndexed { i, viewId ->
                    val metricId = others.getOrNull(i)
                    val line = if (metricId != null) {
                        widgetData.getString("widget_metric_${metricId}_line", "--")
                    } else {
                        "--"
                    }
                    setTextViewText(viewId, line)

                    if (metricId != null) {
                        val setHeadlineIntent = Intent(context, SeaConditionWidgetProvider::class.java).apply {
                            action = ACTION_SET_HEADLINE
                            // A unique data Uri (not just extras) is what makes each of
                            // these PendingIntents distinct — Android treats two
                            // PendingIntents with the same action/component/data as
                            // "the same" regardless of extras, which would otherwise
                            // make every row fire whichever intent was built last.
                            data = Uri.parse("shorecast://headline/$widgetId/$metricId")
                            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                            putExtra(EXTRA_METRIC_ID, metricId)
                        }
                        val setHeadlinePendingIntent = PendingIntent.getBroadcast(
                            context,
                            widgetId,
                            setHeadlineIntent,
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                        )
                        setOnClickPendingIntent(viewId, setHeadlinePendingIntent)
                    }
                }

                setTextViewText(
                    R.id.widget_updated,
                    widgetData.getString("widget_updated_line", "Updated --")
                )

                // Color the rating pill to match the app's good/fair/poor scale.
                val pillRes = when (widgetData.getString("widget_rating_bucket", "fair")) {
                    "good" -> R.drawable.widget_pill_good
                    "poor" -> R.drawable.widget_pill_poor
                    else -> R.drawable.widget_pill_fair
                }
                setInt(R.id.widget_rating_pill, "setBackgroundResource", pillRes)

                // Manual refresh button: broadcasts to a background receiver that
                // runs `widgetInteractivityCallback` in lib/main.dart, which
                // fetches fresh data and calls WidgetService.pushUpdate again.
                val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("shorecast://refresh")
                )
                setOnClickPendingIntent(R.id.widget_refresh_button, refreshIntent)

                // Gear icon: reopen this widget instance's configure screen.
                // Android only auto-shows android:configure once, at add-time —
                // this is the only way to change the headline metric afterward.
                val configureIntent = Intent(context, WidgetConfigureActivity::class.java).apply {
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val configurePendingIntent = PendingIntent.getActivity(
                    context,
                    widgetId, // unique per widget instance so PendingIntents don't collide
                    configureIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(R.id.widget_settings_button, configurePendingIntent)

                // Tapping anywhere else on the widget opens the app.
                val launchIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, launchIntent)
            }
        }
    }
}
