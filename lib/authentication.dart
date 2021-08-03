// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
//
// class Authentication{
//
//   String role="";
//   checkUserRole() async {
//   String uid = FirebaseAuth.instance.currentUser!.uid.toString();
//   final userRef = FirebaseFirestore.instance.collection("UsersDetails");
//   await userRef.where('uid',isEqualTo: uid).get().then((
//   QuerySnapshot value) => value.docs.forEach((DocumentSnapshot element) {
//   if((element.data() as Map<String,dynamic>)['Role'] == 'Admin'){
//   role = "Admin";
//   }else if((element.data() as Map<String,dynamic>)['Role'] == 'User'){
//   role = "User";
//   }else{
//     role = "Unauthorized";
//   }
//   }));
//   return role;
//   }
//
// }
import 'package:admission_portfolio/Pages/adminPage.dart';
import 'package:admission_portfolio/Pages/login.dart';
import 'package:admission_portfolio/Pages/userScreen.dart';
import 'package:admission_portfolio/loadingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot){
           if(snapshot.hasData){
             if(checkUserRole() == 'Admin')AdminPage();
             else if(checkUserRole() == 'User')HomePage();
             else LoaderPage();
           }
           if(snapshot.connectionState == ConnectionState.waiting){
             return LoaderPage();
           }
           return Login();
        }

    );
  }
}


  checkUserRole() async {
   String role ="";
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  final userRef = FirebaseFirestore.instance.collection("UsersDetails");
  await userRef.where('uid',isEqualTo: uid).get().then((
  QuerySnapshot value) => value.docs.forEach((DocumentSnapshot element) {
  if((element.data() as Map<String,dynamic>)['Role'] == 'Admin'){
  role = "Admin";
  }else if((element.data() as Map<String,dynamic>)['Role'] == 'User'){
  role = "User";
  }else{
    role = "Unauthorized";
  }
  }));
  return role;
  }





