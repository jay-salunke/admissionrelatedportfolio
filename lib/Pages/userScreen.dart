import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Reference> files = [];

  Future<void> getFileNames() async {
    files = (await FirebaseStorage.instance.ref().listAll()).items;
  }

  // void downloadFile(int index){
  //   // Directory appDocDir = await getApplicationDocumentsDirectory();
  //   Reference file = files[index];
  //   File downloadToFile = File('/storage/emulated/0/Download/${file.name}');
  //   print(downloadToFile);
  //
  //   try {
  //     file.writeToFile(downloadToFile);
  //   } on FirebaseException catch (e) {
  //       print(e.message);
  //   }
  // }

  void downloadFile(int index) async {
    final ref = FirebaseStorage.instance.ref().child(
        '${files[index].name.toString()}');
    final getUrl = ref.getDownloadURL().toString();
    int num = 0;
    int tempNum = 0;

    final regex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    File file = new File('/storage/emulated/0/Download/${files[index].name}');
    String fileName = basenameWithoutExtension(file.path);
    if (await file.exists()) {
      print(fileName);

      for (int i = 0; i < fileName.length; i++) {
        try {
          if (regex.hasMatch(fileName[i]))
            num = num * 10 + int.parse(fileName[i]);
        } on FormatException catch (e) {
          print(e);
        }
      }
      tempNum = num;
      num++;
      String newFileName =
      files[index].name.replaceAll(tempNum.toString(), num.toString());
      print(newFileName);
      File newFile = File('storage/emulated/0/Download/$newFileName');
      Reference reference = files[index];
      reference.writeToFile(newFile);
    }
  }

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
            if (snapshot.connectionState == ConnectionState.none) {
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
                                downloadFile(index);
                              },
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }
}
