// Copy this file to:
//   android/app/src/main/kotlin/<your/package/path>/WidgetConfigureActivity.kt
// (same package/folder as SeaConditionWidgetProvider.kt and MainActivity.kt)
// and make sure the `package` line below matches your applicationId.
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
// The whole screen is built in code rather than from a layout XML file —
// there's nothing here complex enough to need one, and it keeps this
// feature to a single file to copy in.
class WidgetConfigureActivity : android.app.Activity() {

    private var appWidgetId: Int = android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID

    // id, human-readable label — order shown in the dropdown. Ids must
    // match WidgetConstants.metricIds in lib/core/constants.dart.
    private val metricOptions = listOf(
        "wave" to "Wave height",
        "wind" to "Wind speed",
        "tide" to "Tide trend",
        "air" to "Air temperature",
        "water" to "Water temperature"
    )

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        // If the user backs out without tapping Save, this must read as a
        // cancelled widget add, per the AppWidget configure-activity contract.
        setResult(RESULT_CANCELED)

        appWidgetId = intent?.extras?.getInt(
            android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,
            android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID

        if (appWidgetId == android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        setContentView(buildLayout())
    }

    private fun buildLayout(): android.view.View {
        val density = resources.displayMetrics.density
        val padding = (24 * density).toInt()
        val spacing = (12 * density).toInt()

        val root = android.widget.LinearLayout(this).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            setPadding(padding, padding, padding, padding)
            setBackgroundColor(0xFF01439A.toInt()) // AppColors.deepNavy
        }

        val title = android.widget.TextView(this).apply {
            text = "Widget headline"
            setTextColor(0xFFF3F8FF.toInt())
            textSize = 20f
            setTypeface(typeface, android.graphics.Typeface.BOLD)
        }
        root.addView(title)

        val subtitle = android.widget.TextView(this).apply {
            text = "Choose which reading shows as the big number on the widget."
            setTextColor(0xFFB9DCF7.toInt())
            textSize = 13f
            setPadding(0, spacing / 2, 0, spacing)
        }
        root.addView(subtitle)

        val currentId = SeaConditionWidgetProvider.primaryMetricFor(this, appWidgetId)
        val currentIndex = metricOptions.indexOfFirst { it.first == currentId }.let { if (it >= 0) it else 0 }

        val spinner = android.widget.Spinner(this)
        val adapter = android.widget.ArrayAdapter(
            this,
            android.R.layout.simple_spinner_item,
            metricOptions.map { it.second }
        )
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinner.adapter = adapter
        spinner.setSelection(currentIndex)
        root.addView(
            spinner,
            android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            )
        )

        var selectedId = metricOptions[currentIndex].first
        spinner.onItemSelectedListener = object : android.widget.AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: android.widget.AdapterView<*>?,
                view: android.view.View?,
                position: Int,
                id: Long
            ) {
                selectedId = metricOptions[position].first
            }
            override fun onNothingSelected(parent: android.widget.AdapterView<*>?) {}
        }

        val saveButton = android.widget.Button(this).apply {
            text = "Save"
            setOnClickListener { onSave(selectedId) }
        }
        val saveParams = android.widget.LinearLayout.LayoutParams(
            android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
            android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
        )
        saveParams.topMargin = spacing * 2
        saveParams.gravity = android.view.Gravity.END
        root.addView(saveButton, saveParams)

        return root
    }

    private fun onSave(selectedId: String) {
        SeaConditionWidgetProvider.savePrimaryMetric(this, appWidgetId, selectedId)

        // Redraw this one widget instance immediately, reusing whatever
        // data Dart already pushed, instead of waiting for the next
        // onUpdate/background refresh.
        val appWidgetManager = android.appwidget.AppWidgetManager.getInstance(this)
        val widgetData = es.antonborri.home_widget.HomeWidgetPlugin.getData(this)
        val views = SeaConditionWidgetProvider.buildRemoteViews(this, appWidgetId, widgetData)
        appWidgetManager.updateAppWidget(appWidgetId, views)

        val resultValue = android.content.Intent().putExtra(
            android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId
        )
        setResult(RESULT_OK, resultValue)
        finish()
    }
}
