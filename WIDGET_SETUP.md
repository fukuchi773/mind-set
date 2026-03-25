# ロック画面ウィジェット実装ガイド

## 概要
Mindsetアプリにロックスクリーンとホームスクリーンウィジェット機能を追加しました。これにより、ユーザーはアプリを開かずに常にインスピレーションが詰まった名言を表示できます。

## 実装内容

### 1. Dart側の実装
- **pubspec.yaml**: `home_widget` と `shared_preferences` パッケージを追加
- **lib/widget_helper.dart**: ウィジェット更新ロジックを管理するクラス
- **lib/main.dart**: アプリ起動時にウィジェットを初期化し、「NEXT INSIGHT」ボタンをタップするたびにウィジェットも更新

### 2. Android側の実装
- **MindsetAppWidget.kt**: AppWidgetプロバイダーの実装
- **mindset_widget.xml**: ウィジェット用UIレイアウト
- **mindset_widget_info.xml**: ウィジェットメタデータ（サイズ、更新頻度、対応デバイスなど）
- **AndroidManifest.xml**: BroadcastReceiverとして登録
- **strings.xml**: ウィジェット用の文字列リソース

### 3. iOS側の実装
- **MindsetWidget.swift**: WidgetKit実装
- **MindsetWidgetBundle.swift**: WidgetKitバンドル定義
- **Runner.entitlements**: App Groups設定

## 手動で必要な設定（Xcode）

### iOS設定（重要）

1. Xcodeを開く: `open ios/Runner.xcworkspace`

2. Widget Extension ターゲットを作成:
   - Product → New Target
   - 「Widget Extension」を選択
   - Product Name: `MindsetWidgetExtension`

3. ウィジェット用Info.plistを編集:
   ```xml
   <key>NSExtension</key>
   <dict>
      <key>NSExtensionPointIdentifier</key>
      <string>com.apple.widgetkit-extension</string>
   </dict>
   ```

4. App Groups Capability を有効化:
   - Signing & Capabilities タブ
   - + Capability でApp Groupsを追加
   - グループIDを `group.com.example.mindset_app` に設定

5. ウィジェット拡張用のSwiftUIコードを実装:
   - `ios/WidgetKit/MindsetWidget.swift` と `MindsetWidgetBundle.swift` をウィジェットターゲットに追加

### Android設定

基本的な設定はファイルで完了しています。ビルド時に以下が自動で処理されます：
- AppWidget用のBroadcastReceiver登録
- メタデータの読み込み
- SharedPreferencesとの連携

## 使用方法

### アプリ内での使用
1. アプリを起動
2. 「NEXT INSIGHT」ボタンをタップして名言をリフレッシュ
3. ウィジェットが自動で更新されます

### ウィジェットの追加方法

**Android:**
1. ホームスクリーンで長押し
2. 「ウィジェット」または「Widget」を選択
3. 「Mindset」を探して、サイズを選択して追加
4. ロック画面にも追加可能（Android 12+）

**iOS:**
1. ロック画面またはホームスクリーンで長押し
2. 「カスタマイズ」を選択
3. ウィジェットを追加または検索
4. 「MindsetWidget」を選択

## トラブルシューティング

### ウィジェットが表示されない場合
- アプリを一度実行してウィジェットを初期化
- キャッシュをクリア: `flutter clean`

### データが同期されない場合
- iOS: App Groupsが正しく設定されているか確認
- Android: AndroidManifest.xmlでreceiverが正しく登録されているか確認

### iOS でビルドエラーが出る場合
1. `flutter clean` を実行
2. Pods をアップデート: `, pod install --repo-update`
3. `flutter run` で再度実行

## 技術仕様

- **更新頻度**: 30分ごと（カスタマイズ可能）
- **サイズ**: Small, Medium, Large に対応
- **プラットフォーム**: Android 5.0+, iOS 15.0+
- **データ共有**: SharedPreferences / UserDefaults

## 今後の改善可能な機能

1. ウィジェット上から名言をシェア
2. ウィジェットのタップでアプリを起動
3. ウィジェット用の詳細設定画面
4. 複数ウィジェットサイズの完全カスタマイズ
5. ウィジェット上のボタンでリフレッシュ
