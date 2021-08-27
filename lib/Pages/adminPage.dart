import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../FileDownload.dart';
import '../loadingPage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<File> selectedFiles = [];
  List<Reference> files = [];
  List<Reference> filteredFiles = [];
  String fileName = "";
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  FileDownload fileDownload = FileDownload();

  @override
  void initState() {
    fileDownload.getFileNames().then((getFiles) {
      setState(() {
        files = filteredFiles = getFiles;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = 0xFF910222;
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
                onTap: () async {
                  await fileDownload.getLocalStorageFiles(selectedFiles)
                      ? showFlash(
                          duration: const Duration(seconds: 4),
                          builder: (context, controller) {
                            return Flash.bar(
                              controller: controller,
                              backgroundGradient: LinearGradient(
                                colors: [Colors.yellow, Colors.amber],
                              ),
                              child: FlashBar(
                                content: Text(
                                  ' ${selectedFiles.length == 1 ? "File is" : "Files are "} uploaded successfully',
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            );
                          },
                          context: context,
                        )
                      : print("File is not selected");
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
      body: filteredFiles.length > 0
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: filteredFiles.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      filteredFiles[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                    dense: true,
                    trailing: IconButton(
                      icon: Icon(Icons.download_outlined),
                      onPressed: () async {
                        final status = Permission.storage.request();
                        if (await status.isGranted) {
                          // downloadFile(index);
                          fileDownload.downloadFile(filteredFiles, index);
                          showFlash(
                            context: context,
                            duration: const Duration(seconds: 4),
                            builder: (context, controller) {
                              return Flash.bar(
                                controller: controller,
                                backgroundGradient: LinearGradient(
                                  colors: [Colors.yellow, Colors.amber],
                                ),
                                child: FlashBar(
                                  content: Text(
                                    '${filteredFiles[index].name} is downloaded successfully',
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Allow the permissions to download files'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              })
          : LoaderPage(),
    );
  }
}
