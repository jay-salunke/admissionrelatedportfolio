import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser!;
    user.sendEmailVerification();

    Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = 0xFF910222;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(mainColor),
        title: Text('Verify Email'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('An email has been sent to ${user.email} please verify '),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future<void> checkEmailVerified() async {
    try {
      user = auth.currentUser!;
      await user.reload();
      if (user.emailVerified) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/authenticate', (route) => false);
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
