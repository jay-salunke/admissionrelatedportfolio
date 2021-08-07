import 'package:admission_portfolio/Pages/VerifyEmail.dart';
import 'package:admission_portfolio/Pages/adminPage.dart';
import 'package:admission_portfolio/Pages/userScreen.dart';
import 'package:admission_portfolio/Pages/login.dart';
import 'package:admission_portfolio/Pages/signUp.dart';
import 'package:admission_portfolio/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admission_portfolio/Pages/firstPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FirstPage(),
    initialRoute: FirebaseAuth.instance.currentUser == null
        ? '/firstPage'
        : '/authenticate',
    routes: <String, WidgetBuilder>{
      '/authenticate': (BuildContext context) => AuthChecker(),
      '/firstPage': (BuildContext context) => FirstPage(),
      '/login': (BuildContext context) => Login(),
      '/signUp': (BuildContext context) => SignupPage(),
      '/homepage': (BuildContext context) => HomePage(),
      '/adminPage': (BuildContext context) => AdminPage(),
      '/verifyEmail':(BuildContext context)=>VerifyEmail(),
    },
  ));
}
