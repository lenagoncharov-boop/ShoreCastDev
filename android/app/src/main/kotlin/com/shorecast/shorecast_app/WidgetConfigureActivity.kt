// Copy this file to:
//   android/app/src/main/kotlin/<your/package/path>/WidgetConfigureActivity.kt
// (same package/folder as SeaConditionWidgetProvider.kt and MainActivity.kt)
// and make sure the `package` line below matches your applicationId.
//
// Also copy android_widget_integration/res/layout/activity_widget_configure.xml
// to android/app/src/main/res/layout/activity_widget_configure.xml, plus the
// three drawables it uses (configure_background.xml, radio_row_background.xml)
// to android/app/src/main/res/drawable/.
//
// Standard Android AppWidget "configure" screen. Android shows this
// automatically the moment the user drags the Sea Conditions widget onto
// their home screen (wired via android:configure in
// sea_condition_widget_info.xml, and the matching <activity> block in
// AndroidManifest.xml). It's also reachable later from the widget's own
// gear icon (see SeaConditionWidgetProvider.buildRemoteViews), since
// Android has no other built-in way to reconfigure an already-placed
// widget.
//
// Five metrics, one choice -- a RadioGroup, not a dropdown: all options
// sit on screen at once, tapping one saves it immediately and closes the
// screen. No Save button: the current/default choice is accepted the
// moment the screen opens (so the widget still gets placed even if the
// user backs out without tapping anything), and any real tap on an
// option immediately confirms that one instead.

package com.moresoft.shorecast

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Intent
import android.os.Bundle
import android.widget.RadioGroup
import es.antonborri.home_widget.HomeWidgetPlugin

class WidgetConfigureActivity : Activity() {

    private var appWidgetId: Int = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // If the user backs out, confirmSelection() below still runs once
        // for the default before that can happen, so RESULT_OK is already
        // set by the time onCreate finishes -- see the comment there.
        setResult(RESULT_CANCELED)

        appWidgetId = intent?.extras?.getInt(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID

        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        // This activity uses a Dialog theme (see AndroidManifest.xml), so it
        // renders as a small floating card with a dimmed area around it.
        // Tapping that dimmed area closes the screen -- handy when the
        // current choice is already the one you want and there's nothing
        // to change (the system back gesture/button also always works).
        setFinishOnTouchOutside(true)

        setContentView(R.layout.activity_widget_configure)

        // On newer Android versions (edge-to-edge is mandatory from Android 15 /
        // API 35 on), a plain Activity's content draws behind the status bar by
        // default -- without this, the title/subtitle at the top of the screen
        // end up hidden underneath it. Pad the root by however tall the system
        // bars actually are, so content always starts below them.
        val root = findViewById<android.view.View>(R.id.configure_root)
        val basePadding = (24 * resources.displayMetrics.density).toInt()
        root.setOnApplyWindowInsetsListener { view, insets ->
            @Suppress("DEPRECATION")
            val topInset = insets.systemWindowInsetTop
            view.setPadding(basePadding, basePadding + topInset, basePadding, basePadding)
            insets
        }
        root.requestApplyInsets()

        val radioIdsByMetric = mapOf(
            R.id.radio_wave to "wave",
            R.id.radio_wind to "wind",
            R.id.radio_tide to "tide",
            R.id.radio_air to "air",
            R.id.radio_water to "water"
        )

        val currentId = SeaConditionWidgetProvider.primaryMetricFor(this, appWidgetId)

        // Accept the current/default choice right away, so the widget still
        // gets placed and shows real data even if the user never touches
        // this screen and just presses back.
        confirmSelection(currentId, closeScreen = false)

        val radioGroup = findViewById<RadioGroup>(R.id.configure_radio_group)
        val currentRadioId = radioIdsByMetric.entries.firstOrNull { it.value == currentId }?.key
            ?: R.id.radio_wave
        // Set BEFORE attaching the listener below, so this programmatic
        // check doesn't itself trigger a "selection" and close the screen.
        radioGroup.check(currentRadioId)

        radioGroup.setOnCheckedChangeListener { _, checkedId ->
            val metricId = radioIdsByMetric[checkedId] ?: return@setOnCheckedChangeListener
            confirmSelection(metricId, closeScreen = true)
        }
    }

    private fun confirmSelection(metricId: String, closeScreen: Boolean) {
        SeaConditionWidgetProvider.savePrimaryMetric(this, appWidgetId, metricId)

        // Redraw this one widget instance immediately, reusing whatever
        // data Dart already pushed, instead of waiting for the next
        // onUpdate/background refresh.
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val widgetData = HomeWidgetPlugin.getData(this)
        val views = SeaConditionWidgetProvider.buildRemoteViews(this, appWidgetId, widgetData)
        appWidgetManager.updateAppWidget(appWidgetId, views)

        val resultValue = Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        setResult(RESULT_OK, resultValue)
        if (closeScreen) finish()
    }
}
