import 'package:admission_portfolio/Pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  bool _validateEmail(String email) {
    RegExp regexemail =
        RegExp("^([a-z\\d\\.-]+)@somaiya\\.edu", caseSensitive: true);
    if (regexemail.hasMatch(email))
      return true;
    else
      return false;
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
      body: Form(
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
                  } else if (!_validateEmail(value))
                    return 'Password is invalid';
                  else
                    return null;
                },
                onChanged: (value) => _emailId = value,
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
                onChanged: (value) => _password = value,
              ),
            ),
            SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontSize: 15,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  child: Text('Forgot Password',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontSize: 15,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  onTap: () {},

                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: () async {
                try {
                  if (_validateForm()) {
                   await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailId, password: _password);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/homepage', (route) => false);

                    }
                }catch(e){
                  print(e);
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
    );
  }
}
