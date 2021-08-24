import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    String _emailID = "";
    const mainColor = 0xFF910222;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();
    final auth = FirebaseAuth.instance;
    bool _validateEmail(String email) {
      RegExp regexemail =
          RegExp("^([\\w\\.]+)@somaiya\\.edu", caseSensitive: true);

      return regexemail.hasMatch(email);
    }

    bool _validateForm() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print('Successful your email is $_emailID');
        return true;
      } else {
        print("Unsuccessful");
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(mainColor),
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Text(
            "Reset Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(mainColor),
              fontSize: 25,
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                    borderSide: BorderSide(color: Color(mainColor), width: 2.0),
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
                onChanged: (value) => _emailID = value,
              ),
            ),
          ),
          RoundedLoadingButton(
            controller: _btnController,
            color: Color(mainColor),
            onPressed: () async {
              if (_validateForm()) {
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
                          'we sent you an email on $_emailID to reset the password kindly check your inbox',
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    );
                  },
                );
                Timer(Duration(seconds: 1), () {
                  _btnController.success();
                });
                await auth.sendPasswordResetEmail(email: _emailID);
              } else {
                _btnController.error();

                Future.delayed(const Duration(milliseconds: 4000), () {
                  _btnController.reset();
                });
              }
            },
            child: Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
