import 'package:http/http.dart';
import 'dart:convert';
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

var bbyte;
Future<String> GetData() async {
  Response response =
      await get(Uri.parse('https://meme-api.herokuapp.com/gimme'));
  Map data = jsonDecode(response.body);
  String link = data['url'];
  bbyte = response.bodyBytes;
  return link;
}

share() async {
  await WcFlutterShare.share(
      sharePopupTitle: 'share with?',
      subject: 'memit',
      text: 'meme',
      fileName: 'meme.png',
      mimeType: 'image/png',
      bytesOfFile: bbyte);
}
