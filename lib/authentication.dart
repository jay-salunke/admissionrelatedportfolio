import 'package:admission_portfolio/Pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid.toString();
      final userRef = FirebaseFirestore.instance.collection("UsersDetails");
      userRef.where('uid', isEqualTo: uid).get().then((QuerySnapshot value) {
        final element = value.docs[0];
        if (element.exists) {
          if ((element.data() as Map<String, dynamic>)['Role'] == 'Admin') {
            Navigator.pushNamedAndRemoveUntil(
                context, '/adminPage', (Route<dynamic> route) => false);
          } else if ((element.data() as Map<String, dynamic>)['Role'] ==
              'User') {
            print("User");
            Navigator.pushNamedAndRemoveUntil(
                context, '/homepage', (Route<dynamic> route) => false);
          }
        } else
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (Route<dynamic> route) => false);
      });
    } else {
      Login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


