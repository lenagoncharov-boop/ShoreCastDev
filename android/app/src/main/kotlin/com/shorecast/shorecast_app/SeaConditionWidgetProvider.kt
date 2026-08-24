// Copy this file to:
//   android/app/src/main/kotlin/<your/package/path>/SeaConditionWidgetProvider.kt
// and fix the `package` line below to match your app's applicationId
// (see android/app/build.gradle.kts -> defaultConfig.applicationId).
//
// Reads the key/value pairs written by lib/services/widget_service.dart
// (via the home_widget plugin) and renders them into the home-screen
// widget's RemoteViews. Two tap targets: the refresh icon re-runs the
// Dart background callback to fetch fresh data; the rest of the widget
// opens the app.

package com.shorecast.shorecast_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class SeaConditionWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.sea_condition_widget).apply {
                setTextViewText(
                    R.id.widget_location,
                    widgetData.getString("widget_location_name", "ShoreCast")
                )
                setTextViewText(
                    R.id.widget_rating,
                    widgetData.getString("widget_rating_label", "--")
                )
                setTextViewText(
                    R.id.widget_wave_height,
                    widgetData.getString("widget_wave_height", "--")
                )
                setTextViewText(
                    R.id.widget_wave_period,
                    "period " + widgetData.getString("widget_wave_period", "--")
                )
                setTextViewText(
                    R.id.widget_wind,
                    "Wind " + widgetData.getString("widget_wind_speed", "--")
                )
                setTextViewText(
                    R.id.widget_temp,
                    "Air " + widgetData.getString("widget_air_temp", "--")
                )
                setTextViewText(
                    R.id.widget_water_temp,
                    "Water " + widgetData.getString("widget_water_temp", "--")
                )
                setTextViewText(
                    R.id.widget_tide,
                    "Tide " + widgetData.getString("widget_tide_trend", "--")
                )
                setTextViewText(
                    R.id.widget_updated,
                    "Updated " + widgetData.getString("widget_updated_at", "--")
                )

                // Manual refresh button: broadcasts to a background receiver that
                // runs `widgetInteractivityCallback` in lib/main.dart, which
                // fetches fresh data and calls WidgetService.pushUpdate again.
                val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("shorecast://refresh")
                )
                setOnClickPendingIntent(R.id.widget_refresh_button, refreshIntent)

                // Tapping anywhere else on the widget opens the app.
                val launchIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, launchIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
