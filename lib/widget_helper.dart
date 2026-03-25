import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quotes.dart';

class WidgetHelper {
  static const String quotesKey = 'mindset_quote';
  static const String authorKey = 'mindset_author';
  static const String groupId = 'com.example.mindset_app';

  // ウィジェットを更新する
  static Future<void> updateWidget(String quote, String author) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(quotesKey, quote);
      await prefs.setString(authorKey, author);

      await HomeWidget.updateWidget(
        name: 'MindsetAppWidget',
        iOSName: 'MindsetWidget',
      );
    } catch (e) {
      print('Failed to update widget: $e');
    }
  }

  // ランダムな名言を取得して、ウィジェット更新
  static Future<void> refreshWidget() async {
    final quote = randomQuote();
    await updateWidget(quote, 'Mindset Refresher');
  }

  // 初期化
  static Future<void> initializeWidget() async {
    try {
      await refreshWidget();
    } catch (e) {
      print('Failed to initialize widget: $e');
    }
  }
}

