import 'dart:async';
import 'package:admission_portfolio/Pages/signUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:ui';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  bool _isVisible = true;
  String _emailId = "";
  String _password = "";

  void checkUserRole() {
    bool _checkUserVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (FirebaseAuth.instance.currentUser != null && _checkUserVerified) {
      String uid = FirebaseAuth.instance.currentUser!.uid.toString();
      final userRef = FirebaseFirestore.instance.collection("UsersDetails");
      userRef.where('uid', isEqualTo: uid).get().then((QuerySnapshot value) {
        final element = value.docs[0];
        if (element.exists) {
          if ((element.data() as Map<String, dynamic>)['Role'] == 'Admin') {
            Timer(Duration(seconds: 1), () {
              _btnController.success();
            });

            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/adminPage', (Route<dynamic> route) => false);
            });
          } else if ((element.data() as Map<String, dynamic>)['Role'] ==
              'User') {
            Timer(Duration(seconds: 1), () {
              _btnController.success();
            });

            Future.delayed(const Duration(milliseconds: 3000), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/homepage', (Route<dynamic> route) => false);
            });
          }
        }
      });
    } else {
      Timer(Duration(seconds: 1), () {
        _btnController.error();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please verify the email first'),
      ));

      Future.delayed(const Duration(milliseconds: 3000), () {
        _btnController.reset();
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _validateEmail(String email) {
    RegExp regexemail =
        RegExp("^([\\w\\.]+)@somaiya\\.edu", caseSensitive: true);

    return regexemail.hasMatch(email);
  }

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Successful your email is $_emailId , and password is $_password');
      return true;
    } else
      print('Unsuccessful');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = 0xFF910222;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(mainColor),
        title: Text(
          'KJ.Somaiya Polytechnic',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Text(
                "Login Form",
                style: TextStyle(
                  color: Color(mainColor),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  obscureText: false,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    fillColor: Colors.green,
                    suffixIcon: Icon(
                      Icons.mail_outline_outlined,
                      color: Color(mainColor),
                    ),
                    labelText: 'Email ID',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
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
                      return 'Email ID is required';
                    else if (!_validateEmail(value))
                      return 'Email ID is invalid';
                    else
                      return null;
                  },
                  onChanged: (value) => _emailId = value,
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
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
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
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
                  obscureText: _isVisible,
                  validator: (value) {
                    if (value!.isEmpty)
                      return 'Password is required';
                    else if (value.length < 8)
                      return 'Password must be more than 8 characters';
                    else
                      return null;
                  },
                  onChanged: (value) => _password = value,
                ),
              ),
              // SizedBox(
              //   height: 15,
              // ),
              SizedBox(
                height: 10,
              ),
              RoundedLoadingButton(
                color: Color(mainColor),
                onPressed: () async {
                  try {
                    if (_validateForm()) {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailId, password: _password);

                      checkUserRole();
                    } else {
                      _btnController.error();

                      Future.delayed(const Duration(milliseconds: 3000), () {
                        _btnController.reset();
                      });
                    }
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
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setState(() {
                        _btnController.reset();
                      });
                    });
                  }
                },
                controller: _btnController,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 90),
                child: Row(
                  children: <Widget>[
                    Text("Don't have an Account? "),
                    GestureDetector(
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
