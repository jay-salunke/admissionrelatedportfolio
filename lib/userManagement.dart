
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserManagement{
  String role="";
   checkUserRole() async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final userRef = FirebaseFirestore.instance.collection("UsersDetails");
    await userRef.where('uid',isEqualTo: uid).get().then((
        QuerySnapshot value) => value.docs.forEach((DocumentSnapshot element) {
      if((element.data() as Map<String,dynamic>)['Role'] == 'Admin'){
        role = "Admin";
      }else if((element.data() as Map<String,dynamic>)['Role'] == 'User'){
        role = "User";
      }
          }));
       return role;
  }
}