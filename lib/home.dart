import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:memeit/getdata.dart';
import 'package:memeit/download.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:permission_handler/permission_handler.dart';

class Meme extends StatefulWidget {
  const Meme({Key? key}) : super(key: key);

  @override
  _MemeState createState() => _MemeState();
}

class _MemeState extends State<Meme> {
  String urlImageApi =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTy-Z1UV3jqf2KJ3KcHkaXc3zhism7dFTnDyw&usqp=CAU";
  _save() async {
    var status = await Permission.storage.request();
    if(status.isGranted){
    var response = await Dio()
        .get(urlImageApi, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    print(result);}
  }

  void initState() {
    super.initState();
    Future<String> link1 = GetData();
    print(link1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("MEMEIT"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 360.0,
              width: 360.0,
              child: Image.network(
                urlImageApi,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            FloatingActionButton(
              onPressed: () {
                GetData().then((String link1) => {
                      setState(() {
                        urlImageApi = link1;
                      })
                    });
              },
              child: Text("MEME"),
              backgroundColor: Colors.deepOrange,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    _save();
                    // download(
                    //   url: urlImageApi,
                    //   fileName: "meme.jpg"
                  },
                  label: Icon(Icons.download),
                  backgroundColor: Colors.deepOrange,
                ),
                SizedBox(width: 20.0),
                FloatingActionButton.extended(
                  onPressed: () {
                    share();
                  },
                  label: Icon(Icons.share),
                  backgroundColor: Colors.deepOrange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future download({required String url, required String fileName}) async {
    await downloadfile(url, fileName);
  }

  Future<File?> downloadfile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    final response = await Dio().get(url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ));
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }
}
