import 'package:flutter/material.dart';
import 'package:share_sample/share_utils.dart'; // 新しいファイルをインポート

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              onPressed: ShareUtils.shareText,
              child: const Text('基本的なテキスト共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ShareUtils.shareMultipleTexts,
              child: const Text('複数行テキスト共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ShareUtils.shareLocalFile,
              child: const Text('ローカルファイル共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ShareUtils.shareMultipleFiles,
              child: const Text('複数ファイル共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ShareUtils.shareAssetImage,
              child: const Text('アセット画像共有'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ShareUtils.shareImage,
              child: const Text('通信取得画像の共有'),
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
 * - await xFile.readAsString(): テキストとしてファイルを��み込み
 * 
 * 注意点：
 * - ファイルパスは実在するファイルを指している必要がある
 * - Web環境では一部機能が制限される
 * - 大きなファイルを扱う場合はメモリ使用に注意
 */
