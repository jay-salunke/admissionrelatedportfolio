import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Home Page'
        ),
          automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Text(
            'Home Page'
        ),
      ),
    );
  }
}
