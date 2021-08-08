import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _name = "";
  String _emailID = "";
  String _pass = "";
  String _confirmPass = "";
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  RegExp _regexName = RegExp('(^[a-z A-Z]+)', caseSensitive: false);
  RegExp _regexEmail =
      RegExp("^([a-z\\d\\.-]+)@somaiya\\.edu", caseSensitive: true);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _validateEmail(String email) {
    if (_regexEmail.hasMatch(email))
      return true;
    else
      return false;
  }


  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      _pass = _password.text;
      _confirmPass = _confirmPassword.text;
      _formKey.currentState!.save();

      print("Success");
      print('$_name');
      print('$_emailID');
      print('$_pass');
      print('$_confirmPass');
      return true;
    } else {
      print("Not Success");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = 0xFF910222;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(mainColor),
        title: Text(
          'KJ Somaiya Polytechnic',
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Signup Form',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      suffixIcon: Icon(Icons.person_add_alt),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return 'Name is required';
                      else if (!_regexName.hasMatch(value))
                        return 'Name is invalid';
                      else
                        return null;
                    },
                    onChanged: (value) => _name = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email ID',
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return 'Email is required';
                      else if (!_validateEmail(value))
                        return 'Email is invalid';
                      else
                        return null;
                    },
                    onChanged: (value) => _emailID = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _password,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility_off_outlined,
                        ),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty)
                        return 'Password is required';
                      else if (value.trim().length < 8)
                        return 'Password must be greater than 8 characters';
                      else
                        return null;
                    },
                    onChanged: (value) => _password.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility_off_outlined,
                        ),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return 'Confirm password field is required';
                      else if (value != _password.text)
                        return 'password is not matching';
                      else
                        return null;
                    },
                    onChanged: (value) => _confirmPassword.text,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  ),
                  onPressed: () async {
                    if (_validateForm()) {
                      try {

                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailID, password: _pass);

                        CollectionReference usersData = FirebaseFirestore
                            .instance
                            .collection('UsersDetails');
                        usersData.add({
                          'Name': _name,
                          'EmailId': _emailID,
                          'password': _pass,
                          'uid':
                              FirebaseAuth.instance.currentUser!.uid.toString(),
                          'Role': 'User',
                        });

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/verifyEmail', (route) => false);

                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, '/homepage', (route) => false);
                      } on FirebaseAuthException catch (e) {
                        print(e.message.toString());
                        showFlash(
                          context: context,
                          duration: const Duration(seconds: 4),
                          builder: (context, controller) {
                            return Flash.bar(
                              controller: controller,
                              backgroundGradient: LinearGradient(
                                colors: [Colors.yellow, Colors.amber],
                              ),
                              child: FlashBar(
                                content: Text(
                                  e.message.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: Icon(Icons.info_outline_rounded),
                                showProgressIndicator: true,
                              ),
                              position: FlashPosition.top,
                              margin: const EdgeInsets.all(10),
                              forwardAnimationCurve: Curves.easeInOut,
                              reverseAnimationCurve: Curves.decelerate,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text(
                    "Signup",
                    style: TextStyle(
                      fontSize: 21.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
