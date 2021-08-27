import 'package:admission_portfolio/loadingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../FileDownload.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Reference> files = [];
  List<Reference> filteredFiles = [];
  bool _isSearch = false;

  void _getInputValue(value) {
    setState(() {
      filteredFiles = files
          .where(
              (file) => file.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  FileDownload fileDownload = new FileDownload();

  @override
  void initState() {
    fileDownload.getFileNames().then((value) {
      setState(() {
        files = filteredFiles = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = 0xFF910222;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(mainColor),
        automaticallyImplyLeading: !_isSearch,
        title: _isSearch
            ? TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: Colors.white,
                  ),
                  hintText: "Search Here",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onChanged: (value) {
                  _getInputValue(value);
                },
              )
            : Text('Download Files'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              setState(() {
                _isSearch = !_isSearch;
                filteredFiles = files;
              });
            },
            icon: _isSearch ? Icon(Icons.cancel) : Icon(Icons.search_outlined),
          ),
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Card(
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.person_outline,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.logout_outlined,
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
