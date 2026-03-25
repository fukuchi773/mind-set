package com.example.mindset_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.content.SharedPreferences

private const val ACTION_REFRESH_QUOTE = "com.example.mindset_app.action.REFRESH_QUOTE"

class MindsetAppWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == ACTION_REFRESH_QUOTE) {
            // 押下時は最新名言を選び直して更新
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisAppWidget = ComponentName(context.packageName, javaClass.name)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(thisAppWidget)
            for (appWidgetId in appWidgetIds) {
                refreshQuote(context)
                updateAppWidget(context, appWidgetManager, appWidgetId)
            }
        }
    }

    override fun onEnabled(context: Context) {
    }

    override fun onDisabled(context: Context) {
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val views = RemoteViews(context.packageName, R.layout.mindset_widget)

    val prefs: SharedPreferences = context.getSharedPreferences("flutter.mindset_app", Context.MODE_PRIVATE)
    val quote = prefs.getString("mindset_quote", "BE YOURSELF. THE WORLD WILL ADJUST.")
        ?: "BE YOURSELF. THE WORLD WILL ADJUST."

    val bgRes = listOf(
        R.drawable.widget_bg_1,
        R.drawable.widget_bg_2,
        R.drawable.widget_bg_3
    ).random()

    views.setImageViewResource(R.id.widget_bg, bgRes)
    views.setTextViewText(R.id.widget_quote, quote)

    // タップで刷新
    val refreshIntent = Intent(context, MindsetAppWidget::class.java).apply {
        action = ACTION_REFRESH_QUOTE
    }
    val pendingIntent = PendingIntent.getBroadcast(
        context,
        0,
        refreshIntent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
    views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

    appWidgetManager.updateAppWidget(appWidgetId, views)
}

private fun refreshQuote(context: Context) {
    val allQuotes = listOf(
        "指示された仕事のその先まで出来て、完璧と言うんだ。",
        "君たちは選ぶことが出来る。不運を嘆く側か、世界を変える側か。さぁ、どっちを選ぶ？",
        "アンディ、いいかい、君は努力してない。グチを並べてるだけ。",
        "あなたに越えられる壁しか、あなたには現れない。",
        "Trade the Gin for the Jam.",
        "今の15分が、明日のソロを変える。",
        "消費ではなく、創造を選択しよう。",
        "自分自身の人生を変えられるのは、自分だけだ。誰も自分の代わりにはなれない。",
        "変化は人生の法則である。過去や現在しか見ない者は、未来を失うことになる。",
        "知性とは、変化に適応できる能力のことだ。",
        "昨日の自分を今の自分が超える。それが人生だ。",
        "物事は変わらない。私たちが変わるのだ。",
        "勇気とは、慣れ親しんだものを手放す力のことである。",
        "迷ったときには、変化する方を選びなさい。",
        "進歩とは良い言葉だが、そのきっかけは変革である。",
        "危険なのは、進化しないことだ。",
        "小さな変化を積み重ねることが、大きな成果につながる。",
        "現状維持は、後退の始まりである。",
        "変化を受け入れる準備ができている者だけが、生き残ることができる。",
        "新しいことを始めるのは勇気がいるが、古いものを守り続けるのもまた勇気である。",
        "失敗を恐れるな。変化を恐れろ。",
        "変化の風が吹いたとき、壁を作る者もいれば、風車を作る者もいる。",
        "最も強い者が生き残るのではなく、唯一生き残ることが出来るのは、変化できる者である。",
        "人生をリセットすることはできないが、スタートボタンはいつでも押せる。",
        "変化を楽しむ心を持て。それが成長の鍵だ。",
        "明日をより良くするためには、今日を変えなければならない。",
        "一歩踏み出すことが、すべての変化の始まりだ。",
        "自分自身が変われば、世界が変わる。",
        "快適な場所を抜け出すこと。そこにこそ、真の成長がある。",
        "何も変えない者は、何も得られない。",
        "変化はチャンスである。それを活かせるかどうかは自分次第だ。"
    )

    val randomQuote = allQuotes.random()
    val prefs = context.getSharedPreferences("flutter.mindset_app", Context.MODE_PRIVATE)
    prefs.edit().putString("mindset_quote", randomQuote).apply()
}
