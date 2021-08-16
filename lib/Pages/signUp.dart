import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _name = "";
  String _emailID = "";
  String _pass = "";
  String _confirmPass = "";
  bool _isVisible = true;
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

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

  void signUp() async {
    Timer(Duration(seconds: 3), () {
      _btnController.success();
    });
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
                    color: Color(mainColor),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(mainColor), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(mainColor),
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Color(mainColor),
                      ),
                      suffixIcon: Icon(
                        Icons.person_add_alt,
                        color: Color(mainColor),
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
                      labelStyle: TextStyle(
                        color: Color(mainColor),
                      ),
                      suffixIcon: Icon(
                        Icons.email,
                        color: Color(mainColor),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(mainColor), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(mainColor),
                          width: 2.0,
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
                    obscureText: _isVisible,
                    controller: _password,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color(mainColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility_off_outlined,
                          color: Color(mainColor),
                        ),
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(mainColor), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(mainColor),
                          width: 2.0,
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
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    obscureText: _isVisible,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      labelStyle: TextStyle(
                        color: Color(mainColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility_off_outlined,
                          color: Color(mainColor),
                        ),
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(mainColor), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(mainColor),
                          width: 2.0,
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
                  height: 10,
                ),
                RoundedLoadingButton(
                    color: Color(mainColor),
                    child: Text('SignUp',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    controller: _btnController,
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
                            'uid': FirebaseAuth.instance.currentUser!.uid
                                .toString(),
                            'Role': 'User',
                          });

                          Timer(Duration(seconds: 1), () {
                            _btnController.success();
                          });
                          Future.delayed(const Duration(milliseconds: 3000),
                              () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/verifyEmail', (route) => false);
                          });
                        } on FirebaseAuthException catch (e) {
                          Timer(Duration(seconds: 1), () {
                            _btnController.error();
                          });

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
                      } else {
                        Timer(Duration(seconds: 1), () {
                          _btnController.error();
                        });
                      }
                      Future.delayed(const Duration(milliseconds: 3000), () {
                        setState(() {
                          _btnController.reset();
                        });
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
