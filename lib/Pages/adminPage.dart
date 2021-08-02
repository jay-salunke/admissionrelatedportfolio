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
        title: Text(
          'AdminPage'
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'Logout',
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            },
            icon: Icon(Icons.logout_outlined),

          ),
        ],
      ),
      body:Center(
        child: Text(
          'Admin Page',
        ),
      ),
    );
  }
}
