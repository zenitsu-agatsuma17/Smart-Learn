import 'dart:io';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PythonMaterial extends StatefulWidget {
  const PythonMaterial({Key? key}) : super(key: key);

  @override
  State<PythonMaterial> createState() => _PythonMaterialState();
}

class _PythonMaterialState extends State<PythonMaterial> {
  String? localPath;
  final String urlPath =
      'https://firebasestorage.googleapis.com/v0/b/final-smart-learn.appspot.com/o/Smart_Learn%2FProgramming%2FPython%2Fpython_material.pdf?alt=media&token=86e6eadb-8bef-47fa-9a16-addad7ea6f48';
  final String driveUrl =
      "https://firebasestorage.googleapis.com/v0/b/final-smart-learn.appspot.com/o/Smart_Learn%2FProgramming%2FPython%2Fpython_material.pdf?alt=media&token=86e6eadb-8bef-47fa-9a16-addad7ea6f48";
  var dio = Dio();

  Future<void> downloadPdf() async {
    final taskId = await FlutterDownloader.enqueue(
      url: urlPath,
      savedDir: '/storage/emulated/0/Download/',
      showNotification: true,
      openFileFromNotification: true,
      fileName: 'python_material.pdf',
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      if (taskId == id && status == DownloadTaskStatus.complete) {
        setState(() {
          localPath = '/storage/emulated/0/Download/python_material.pdf';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Python Material'),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
              onPressed: () async {
                String path =
                    await ExternalPath.getExternalStoragePublicDirectory(
                        ExternalPath.DIRECTORY_DOWNLOADS);
                String fullPath = "$path/python_material.pdf";
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
