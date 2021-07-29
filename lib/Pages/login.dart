import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isVisible = true;

  TextEditingController _password = TextEditingController();
  TextEditingController _emailID = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            fontFamily: 'NotoSansKR',
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
                      return 'Email field is required';
                    }
                    return null;
                  },
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
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Success");
                  } else {
                    print("Unsuccesful");
                  }
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
