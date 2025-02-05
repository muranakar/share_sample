import 'package:share_plus/share_plus.dart'; // 共有機能を提供するパッケージ
import 'package:path_provider/path_provider.dart'; // ファイルパス取得用パッケージ
import 'dart:io'; // ファイル操作用
import 'package:http/http.dart' as http; // ネットワークリクエスト用
import 'package:flutter/services.dart'; // アセットアクセス用

/// ShareUtils クラス
/// アプリ内での様々な共有機能を提供するユーティリティクラス
class ShareUtils {
  /// テキストを共有するメソッド
  /// URLなどの単純なテキストを他のアプリに共有する
  /// subject: メールの件名などに使用されるタイトル
  static void shareText() {
    Share.share(
      'Flutter開発に関する情報はこちら https://example.com',
      subject: '興味深い記事を見つけました！',
    );
  }

  /// 複数行のテキストを共有するメソッド
  /// 箇条書きなど、フォーマットされたテキストを共有する
  /// subject: メールの件名などに使用されるタイトル
  static void shareMultipleTexts() {
    Share.share(
      '最新のFlutter情報:\n'
      '1. フレームワークの更新\n'
      '2. 新機能の追加\n'
      '3. パフォーマンスの改善\n'
      '\n詳細: https://example.com',
      subject: 'Flutter最新情報まとめ',
    );
  }

  /// ローカルファイルを共有するメソッド
  /// 手順:
  /// 1. アプリのドキュメントディレクトリを取得
  /// 2. テキストファイルを作成して内容を書き込み
  /// 3. XFileオブジェクトに変換して共有
  static Future<void> shareLocalFile() async {
    try {
      // アプリのドキュメントディレクトリのパスを取得
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/hello.txt';

      // ファイルを作成し、内容を書き込む
      final file = File(filePath);
      await file.writeAsString('Hello from Flutter!');

      // 共有用のXFileオブジェクトを作成
      final xFile = XFile(filePath);
      final result = await Share.shareXFiles(
        [xFile],
        text: 'テキストファイルを共有します',
      );

      // 共有結果の確認
      if (result.status == ShareResultStatus.success) {
        print('ファイルの共有が成功しました');
      }
    } catch (e) {
      print('ファイル共有でエラーが発生しました: $e');
    }
  }

  /// オンライン画像を共有するメソッド
  /// 手順:
  /// 1. 画像をダウンロード
  /// 2. 一時ディレクトリに保存
  /// 3. XFileオブジェクトとして共有
  static Future<void> shareImage() async {
    try {
      // オンライン画像のダウンロード
      final imageUrl =
          'https://github.com/user-attachments/assets/2c332e7e-8e46-4e54-a825-f702914ddb0f';
      final response = await http.get(Uri.parse(imageUrl));

      // 一時ディレクトリに画像を保存
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/shared_image.jpg';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(response.bodyBytes);

      // MIMEタイプを指定してXFileを作成
      final xFile = XFile(
        imagePath,
        mimeType: 'image/jpeg',
      );
      final result = await Share.shareXFiles(
        [xFile],
      );

      if (result.status == ShareResultStatus.success) {
        print('画像の共有が成功しました');
      }
    } catch (e) {
      print('画像共有でエラーが発生しました: $e');
    }
  }

  /// 複数のファイルを同時に共有するメソッド
  /// 異なる種類のファイル（テキスト、JSON）を一度に共有する
  static Future<void> shareMultipleFiles() async {
    try {
      // アプリのドキュメントディレクトリを取得
      final directory = await getApplicationDocumentsDirectory();

      // テキストファイルの作成
      final textFile = File('${directory.path}/note.txt');
      await textFile.writeAsString('テキストメモ');

      // JSONファイルの作成
      final jsonFile = File('${directory.path}/data.json');
      await jsonFile.writeAsString('{"message": "JSONデータ"}');

      // 複数のXFileオブジェクトを作成（MIMEタイプを適切に設定）
      final files = [
        XFile(textFile.path, mimeType: 'text/plain'),
        XFile(jsonFile.path, mimeType: 'application/json'),
      ];
      final result = await Share.shareXFiles(
        files,
      );

      if (result.status == ShareResultStatus.success) {
        print('複数ファイルの共有が成功しました');
      }
    } catch (e) {
      print('複数ファイル共有でエラーが発生しました: $e');
    }
  }

  /// アプリのアセットから画像を共有するメソッド
  /// 手順:
  /// 1. アセットから画像データを読み込み
  /// 2. 一時ファイルとして保存
  /// 3. XFileオブジェクトとして共有
  static Future<void> shareAssetImage() async {
    try {
      // アセットから画像データを読み込む
      final byteData = await rootBundle.load('assets/icon.jpeg');

      // 一時ディレクトリに画像を保存
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/icon.jpeg';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(byteData.buffer.asUint8List());

      // MIMEタイプを指定してXFileを作成
      final xFile = XFile(
        imagePath,
        mimeType: 'image/jpeg',
      );
      final result = await Share.shareXFiles(
        [xFile],
      );

      if (result.status == ShareResultStatus.success) {
        print('アセット画像の共有が成功しました');
      }
    } catch (e) {
      print('アセット画像共有でエラーが発生しました: $e');
    }
  }

  /// URIを共有するメソッド
  /// 手順:
  /// 1. URIを指定して共有シートを表示
  /// 2. iOSではシステムがHTMLページを取得し、アイコンを抽出して表示
  /// 3. iPadやMacでは共有シートのポップオーバー位置を指定可能
  ///
  /// [uri]: 共有するURI
  /// [sharePositionOrigin]: 共有シートのポップオーバー位置（iPadやMacのみ）
  static Future<ShareResult> shareUri(
    Uri uri, {
    Rect? sharePositionOrigin,
  }) async {
    return Share.shareUri(
      uri,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
