import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
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

  @override
  Widget build(BuildContext context) {
    const mainColor = 0xFF910222;
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
              showFlash(
                duration: const Duration(seconds: 4),
                builder: (context, controller) {
                  return Flash.bar(
                    controller: controller,
                    backgroundGradient: LinearGradient(
                      colors: [Colors.yellow, Colors.amber],
                    ),
                    child: FlashBar(
                      content: Text(
                        '$fileName is uploaded successfully',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                      ),
                      showProgressIndicator: true,
                    ),
                    position: FlashPosition.top,
                    margin: const EdgeInsets.all(10),
                    forwardAnimationCurve: Curves.easeInOut,
                    reverseAnimationCurve: Curves.decelerate,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  );
                },
                context: context,
              );
            });
          });
        } else {
          print("Selection is cancelled");
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('AdminPage'),
        centerTitle: true,
        backgroundColor: Color(mainColor),
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
                  'Upload Files',
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
                leading: Icon(
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
            Card(
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.person_outlined,
                  color: Colors.red,
                  size: 25,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {
                  print("Profile");
                },
              ),
            ),
            Card(
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                  size: 25,
                ),
                title: Text(
                  'SignOut',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
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
