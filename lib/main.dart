import 'package:admission_portfolio/Pages/homepage.dart';
import 'package:admission_portfolio/Pages/login.dart';
import 'package:admission_portfolio/Pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admission_portfolio/Pages/firstpage.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home:FirstPage(),
    initialRoute: FirebaseAuth.instance.currentUser == null?'/firstPage':'/homepage',
    routes: <String,WidgetBuilder>{
      '/firstPage':(BuildContext context)=>FirstPage(),
      '/login':(BuildContext context)=>Login(),
      '/signUp':(BuildContext context)=>SignupPage(),
      '/homepage':(BuildContext context)=>HomePage(),
    },
  ));
}


