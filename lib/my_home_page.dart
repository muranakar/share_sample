import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // テキストを共有するメソッド
  // 基本的なテキスト共有
  void _shareText() {
    Share.share(
      'Flutter開発に関する情報はこちら https://example.com',
      subject: '興味深い記事を見つけました！',
    );
  }

  // 複数のテキストを共有するメソッド
  void _shareMultipleTexts() {
    Share.share(
      '最新のFlutter情報:\n'
      '1. フレームワークの更新\n'
      '2. 新機能の追加\n'
      '3. パフォーマンスの改善\n'
      '\n詳細: https://example.com',
      subject: 'Flutter最新情報まとめ',
    );
  }

  // ローカルファイルを共有するメソッド
  void _shareLocalFile() async {
    // assets/hello.txtファイルを共有する例
    try {
      // アプリのドキュメントディレクトリを取得
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/hello.txt';

      // テスト用にファイルを作成
      final file = File(filePath);
      await file.writeAsString('Hello from Flutter!');

      // XFileオブジェクトを作成して共有
      final xFile = XFile(filePath);
      final result = await Share.shareXFiles(
        [xFile],
        text: 'テキストファイルを共有します',
      );

      if (result.status == ShareResultStatus.success) {
        print('ファイルの共有が成功しました');
      }
    } catch (e) {
      print('ファイル共有でエラーが発生しました: $e');
    }
  }

  // 画像ファイルを共有するメソッド
  void _shareImage() async {
    try {
      // オンライン画像のURLを指定
      final imageUrl =
          'https://github.com/user-attachments/assets/2c332e7e-8e46-4e54-a825-f702914ddb0f';
      final response = await http.get(Uri.parse(imageUrl));

      // 一時ディレクトリを取得
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/shared_image.jpg';

      // 画像をローカルに保存
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(response.bodyBytes);

      // XFileオブジェクトを作成して共有
      final xFile = XFile(
        imagePath,
        mimeType: 'image/jpeg', // MIMEタイプを指定
      );

      final result = await Share.shareXFiles(
        [xFile],
        text: '素敵な画像を見つけました！',
        subject: '共有画像',
      );

      if (result.status == ShareResultStatus.success) {
        print('画像の共有が成功しました');
      }
    } catch (e) {
      print('画像共有でエラーが発生しました: $e');
    }
  }

  // 複数のファイルを共有するメソッド
  void _shareMultipleFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      // テスト用に複数のファイルを作成
      final textFile = File('${directory.path}/note.txt');
      await textFile.writeAsString('テキストメモ');

      final jsonFile = File('${directory.path}/data.json');
      await jsonFile.writeAsString('{"message": "JSONデータ"}');

      // 複数のXFileオブジェクトを作成
      final files = [
        XFile(textFile.path, mimeType: 'text/plain'),
        XFile(jsonFile.path, mimeType: 'application/json'),
      ];

      final result = await Share.shareXFiles(
        files,
        text: '複数のファイルを共有します',
        subject: 'ファイル共有テスト',
      );

      if (result.status == ShareResultStatus.success) {
        print('複数ファイルの共有が成功しました');
      }
    } catch (e) {
      print('複数ファイル共有でエラーが発生しました: $e');
    }
  }

  // assets内の画像ファイルを共有するメソッド
  void _shareAssetImage() async {
    try {
      // assets/icon.jpegファイルのパスを指定
      final byteData = await rootBundle.load('assets/icon.jpeg');
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/icon.jpeg';

      // 画像をローカルに保存
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(byteData.buffer.asUint8List());

      // XFileオブジェクトを作成して共有
      final xFile = XFile(
        imagePath,
        mimeType: 'image/jpeg', // MIMEタイプを指定
      );

      final result = await Share.shareXFiles(
        [xFile],
        text: 'アセット画像を共有します！',
        subject: '共有アセット画像',
      );

      if (result.status == ShareResultStatus.success) {
        print('アセット画像の共有が成功しました');
      }
    } catch (e) {
      print('アセット画像共有でエラーが発生しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _shareText,
              child: const Text('基本的なテキスト共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _shareMultipleTexts,
              child: const Text('複数行テキスト共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _shareLocalFile,
              child: const Text('ローカルファイル共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _shareImage,
              child: const Text('画像共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _shareMultipleFiles,
              child: const Text('複数ファイル共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _shareAssetImage,
              child: const Text('アセット画像共有'),
            ),
          ],
        ),
      ),
    );
  }
}

/* XFileについての補足説明
 * XFileとは：
 * - クロスプラットフォームでファイルを扱うためのラッパークラス
 * - iOS、Android、Webなど異なるプラットフォーム間でファイルを統一的に扱える
 * 
 * 主な特徴：
 * 1. プラットフォーム非依存
 * 2. ファイルパス、MIMEタイプ、名前などの基本情報を保持
 * 3. ファイルの読み書きを抽象化
 * 
 * 使用例：
 * - XFile(filePath): 基本的な初期化
 * - XFile(filePath, mimeType: 'type'): MIMEタイプを指定
 * - await xFile.readAsBytes(): バイトとしてファイルを読み込み
 * - await xFile.readAsString(): テキストとしてファイルを読み込み
 * 
 * 注意点：
 * - ファイルパスは実在するファイルを指している必要がある
 * - Web環境では一部機能が制限される
 * - 大きなファイルを扱う場合はメモリ使用に注意
 */
