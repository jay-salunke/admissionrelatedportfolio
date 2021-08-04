import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  // void _getStorageData() async {
  //   final storage = FirebaseStorage.instance.ref();
  //   final storageUrl = FirebaseStorage.instance.bucket;
  //   final listingAll = FirebaseStorage.instance.ref().listAll();
  //   final length = FirebaseStorage.instance.bucket.length;
  //   print(storage);
  //   print(storageUrl);
  //   print(listingAll);
  //   print(length);
  //
  //   ListResult result =
  //       await FirebaseStorage.instance.ref().list(ListOptions(maxResults: 10));
  //
  //   result.items.forEach((Reference element) {
  //     print("File names: " + element.toString());
  //   });
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
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 50,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text('ListView' + index.toString(),
                          style:TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),),
                        dense: true,
                        trailing: IconButton(
                          icon: Icon(Icons.download_outlined),
                          onPressed: () {
                            print("Download file: " + index.toString());
                          },

                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
