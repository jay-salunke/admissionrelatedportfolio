import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<File> selectedFiles = [];
  String fileName = "";
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  UploadTask uploadFileToStorage(File file) {
    fileName = basename(file.path);
    UploadTask task = firebaseStorage.ref(fileName).putFile(file);

    return task;
  }

  Future getMultipleFiles() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        selectedFiles.clear();
        result.files.forEach((selectedFile) {
          File file = new File(selectedFile.path.toString());
          selectedFiles.add(file);
          selectedFiles.forEach((file) {
            uploadFileToStorage(file);
          });
        });
      } else {
        print("Selection is cancelled");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AdminPage'),
        centerTitle: true,
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
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.add,
                  color: Colors.red,
                  size: 25,
                ),
                title: Text(
                  'New',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {
                  getMultipleFiles();
                },
              ),
            ),
            Card(
              child: ListTile(
                dense: true,
                trailing: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 24,
                ),
                title: Text(
                  'Delete Files',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {
                  print("Upload");
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Admin Page',
        ),
      ),
    );
  }
}
