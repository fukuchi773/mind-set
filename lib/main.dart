import 'package:flutter/material.dart';
import 'dart:math';
import 'widget_helper.dart';
import 'quotes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WidgetHelper.initializeWidget();
  runApp(MindsetApp());
}

class MindsetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindset Refresher',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Georgia', // 少し厳格で知的な印象のフォント
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // --- 全名言データセット ---
  // `quotes.dart` の allQuotes を使います。

  // 背景画像（Unsplashからギターやジャズのイメージ）
  final List<String> backgroundImages = [
    "https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=800", // Guitar
    "https://images.unsplash.com/photo-1514525253344-961fce0adcd3?w=800", // Jazz Club
    "https://images.unsplash.com/photo-1415202336109-df1b3d0e70ab?w=800", // Piano/Jazz
    "https://images.unsplash.com/photo-1558021212-51b6ecfa0db9?w=800", // Library/Study
  ];

  late String currentQuote;
  late String currentImage;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      currentQuote = randomQuote();
      currentImage = backgroundImages[Random().nextInt(backgroundImages.length)];
    });
    // ウィジェットも更新
    WidgetHelper.updateWidget(currentQuote, 'Mindset Refresher');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景画像 + オーバーレイ
          Positioned.fill(
            child: Image.network(
              currentImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          // コンテンツ
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 40),
                  const SizedBox(height: 40),
                  Text(
                    currentQuote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 60),
                  OutlinedButton(
                    onPressed: _refresh,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      "NEXT INSIGHT",
                      style: TextStyle(color: Colors.amber, letterSpacing: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 下部のステータス
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "STAY FOCUSED. CREATE SOMETHING.",
                style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}