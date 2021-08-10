import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
            ListTile(
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
              onTap: () {},
            ),
            ListTile(
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
