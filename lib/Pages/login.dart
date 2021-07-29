import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isVisible = true;

  String _emailId = "";
  String _password = "";


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _ValidateEmail(String email) {
    RegExp regexemail =
        RegExp("^([a-z\\d\\.-]+)@somaiya\\.edu", caseSensitive: true);
    if (regexemail.hasMatch(email))
      return true;
    else
      return false;
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Successful your email is $_emailId , and password is $_password');
    } else
      print('Unsuccessful');
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
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login Form",
                style: TextStyle(
                  fontSize: 30.0,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 20.0,
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
                    suffixIcon: Icon(Icons.mail_outline_outlined),
                    labelText: 'Email ID',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password field is required';
                    } else if (!_ValidateEmail(value))
                      return 'Password is invalid';
                    else
                      return null;
                  },
                  onSaved: (value) => _emailId = value!,
                ),
              ),
              SizedBox(
                height: 16,
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
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
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
                  onSaved: (value) => _password = value!,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                onPressed: () {
                  _validateForm();
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 21.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
