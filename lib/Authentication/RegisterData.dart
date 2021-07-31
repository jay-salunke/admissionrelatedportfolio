import 'package:cloud_firestore/cloud_firestore.dart';
import'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Authenticate{
   FirebaseAuth _auth = FirebaseAuth.instance;


  /*Stream basically just tell us that user logged in has changed or not
   i.e if user is already logged in it will directly shows the home page else
   it will show the authentication page
   */




  Future<void> storeData(String name,String emailId,String password) async{
     String uid = _auth.currentUser!.uid.toString();
    CollectionReference usersData = FirebaseFirestore.instance.collection('UsersDetails');
    usersData.add({
      'uid':uid,
      'Name':name,
      'Email_id':emailId,
      'password':password,
    });

    return;
  }

  Future<void> emailPassword(String emailId,String password) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailId, password: password);
    }catch(signUpError){
          if(signUpError is PlatformException){
            if(signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE'){
              print('Email is already in used');
            }
          }
    }
     return ;
  }
  //register with firebase




}