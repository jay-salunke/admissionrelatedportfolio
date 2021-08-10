

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

// import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    List<Reference> files = [];
    String getUrl = "";
    Future<void> getFileNames() async {
      files = (await FirebaseStorage.instance.ref().listAll()).items;
    }

    void downloadFiles(int index) async {
      // int counter = 1;
      // Directory appDocDir = await getTemporaryDirectory();
      // print(appDocDir);
      // Reference file = files[index];
      // File fileLocation = File('${appDocDir.path}/${files[index].name}');
      // file.writeToFile(fileLocation);
      // final getDownloadUrlFile = files[index].name;
      // Directory? appDocDir = await getExternalStorageDirectory();
      // final status = await Permission.storage.request();
      // //  final filename = files[index].name;
      //
      //   if (status.isGranted) {
      //       print(appDocDir!.path);
      //        final taskId = await FlutterDownloader.enqueue(
      //         url: 'https://firebasestorage.googleapis.com/v0/b/admissionrelatedportfoli-2b429.appspot.com/o/My%20File.xlsx?alt=media&token=03e942eb-eda1-4eea-a1d1-44efdbcb82bc',
      //         savedDir: appDocDir.path,
      //         // savedDir: '/storage/emulated/0/Download/',
      //         showNotification: true,
      //         openFileFromNotification: true,
      //
      //       );
      //   } else {
      //     print("Not able to download");
      //   }
      print(files[index]);
      Directory dir = Directory('AdmissionPortfolio').create(recursive: true) as Directory;
       //final getDir = await getApplicationDocumentsDirectory();
       Dio dio = new Dio();
       dio.download('https://firebasestorage.googleapis.com/v0/b/admissionrelatedportfoli-2b429.appspot.com/o/faculty%20position.docx?alt=media&token=6f8309e8-2db9-47c9-9733-7d315aec17da',dir.path);
    // Reference file = files[index];

      // print(url);
     // print(url);
     // final status  = await Permission.storage.request();
     // if(status.isGranted){
     //    Dio dio = new Dio();
     //    dio.download(urlPath, savePath)
     //
     // }else{
     //   await Permission.storage.request();
     // }
  }

    // print(files[index].getDownloadURL().toString());
    // final getDir = await getExternalStorageDirectory();
    // Dio dio = new Dio();
    // dio.download('https://console.firebase.google.com/u/1/project/admissionrelatedportfoli-2b429/storage/admissionrelatedportfoli-2b429.appspot.com/files/${files[index].name}', getDir!.path);


    // void createFile() async {
    //   final directory = await getApplicationDocumentsDirectory();
    //   final fileLocation = '$directory/${files[index].name}';
    //   final file = File(fileLocation);
    // }


    // try {
    //
    //   file.writeToFile(downloadToFile);
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("${file.name} is downloaded at /storage/emulated/0/Download/"),
    //   ));
    // } on FirebaseException catch (e) {
    //     print(e.message);
    // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Files'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getFileNames(),
           builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.none){
                print("No Files are there");
                return Text('No Files are there');
            }

              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                files[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              dense: true,
                              trailing: IconButton(
                                icon: Icon(Icons.download_outlined),
                                onPressed: () async {
                                  downloadFiles(index);
                                },
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
           }

        ),
    );
  }
}
