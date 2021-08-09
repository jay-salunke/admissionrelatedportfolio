import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Pages/login.dart';
import 'Pages/homePage.dart';
import 'Pages/adminPage.dart';
import 'Pages/verifyEmail.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  late var page;

  @override
  void initState() {
    super.initState();
    bool _checkEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (_checkEmailVerified) {
      final userRef = FirebaseFirestore.instance.collection("UsersDetails");
      userRef
          .where('uid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
          .get()
          .then((QuerySnapshot value) {
        final element = value.docs[0];
        page = (element.exists)
            ? ((element.data() as Map<String, dynamic>)['Role'] == "Admin")
                ? "AdminPage"
                : "HomePage"
            : "Login";
      });
    } else {
      page = "VerifyEmail";
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (page) {
      case "Login":
        return Login();
      case "HomePage":
        return HomePage();
      case "AdminPage":
        return AdminPage();
      case "VerifyEmail":
        return VerifyEmail();
      default:
        return Login();
    }
  }
}
