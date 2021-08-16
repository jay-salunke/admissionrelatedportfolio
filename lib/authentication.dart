import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  var page;

  @override
  void initState() {
    super.initState();
    bool _checkEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    print(_checkEmailVerified);
    try {
      if (_checkEmailVerified) {
        final userRef = FirebaseFirestore.instance.collection("UsersDetails");
        userRef
            .where('uid',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
            .get()
            .then((QuerySnapshot value) {
          final element = value.docs[0];
              (element.exists)
              ? ((element.data() as Map<String, dynamic>)['Role'] == "Admin")
              ? Navigator.pushNamedAndRemoveUntil(context, '/adminPage', (route) => false)
              :  Navigator.pushNamedAndRemoveUntil(context, '/homepage', (route) => false)
              : Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/verifyEmail', (route) => false);
      }
    }on FirebaseAuthException catch(e){
       print(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
