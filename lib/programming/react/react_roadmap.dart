import 'dart:io';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class ReactRoadMap extends StatefulWidget {
  const ReactRoadMap({Key? key}) : super(key: key);

  @override
  State<ReactRoadMap> createState() => _ReactRoadMapState();
}

class _ReactRoadMapState extends State<ReactRoadMap> {
  String? localPath;
  final String urlPath =
      'https://firebasestorage.googleapis.com/v0/b/final-smart-learn.appspot.com/o/Smart_Learn%2FProgramming%2FReact%2Freact_roadmap.pdf?alt=media&token=1d8f40c3-206d-49f5-a93f-e41211ed8de3';
  final String driveUrl =
      "https://firebasestorage.googleapis.com/v0/b/final-smart-learn.appspot.com/o/Smart_Learn%2FProgramming%2FReact%2Freact_roadmap.pdf?alt=media&token=1d8f40c3-206d-49f5-a93f-e41211ed8de3";
  var dio = Dio();

  Future<void> downloadPdf() async {
    final taskId = await FlutterDownloader.enqueue(
      url: urlPath,
      savedDir: '/storage/emulated/0/Download/',
      showNotification: true,
      openFileFromNotification: true,
      fileName: 'react_roadmap.pdf',
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      if (taskId == id && status == DownloadTaskStatus.complete) {
        setState(() {
          localPath = '/storage/emulated/0/Download/react_roadmap.pdf';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('React RoadMap'),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
              onPressed: () async {
                String path =
                    await ExternalPath.getExternalStoragePublicDirectory(
                        ExternalPath.DIRECTORY_DOWNLOADS);
                String fullPath = "$path/react_roadmap.pdf";
                download2(dio, driveUrl, fullPath);
              }, // Call downloadPdf function when clicked
              icon: Icon(Icons.file_download_sharp),
            ),
          ),
        ],
      ),
      body: FutureBuilder<PDFDocument>(
        future: PDFDocument.fromURL(urlPath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PDFViewer(
              document: snapshot.data!,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading PDF'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void getPermission() async {
    if (await Permission.storage.request().isGranted) {
      print('Get Permission');
    }
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print("Error is");
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }
}
