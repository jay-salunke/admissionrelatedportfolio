import 'package:flutter/material.dart';
import 'package:admission_portfolio/Authentication/RegisterData.dart';
import 'package:admission_portfolio/Pages/login.dart';



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
  final Authenticate authenticate = Authenticate();
  @override
  void dispose() {

    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  RegExp _regexName = RegExp('([a-z A-z]+)', caseSensitive: false);
  RegExp _regexEmail =
      RegExp("^([a-z\\d\\.-]+)@somaiya\\.edu", caseSensitive: true);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _validateEmail(String email) {
    if (_regexEmail.hasMatch(email))
      return true;
    else
      return false;
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      _pass = _password.text;
      _confirmPass = _confirmPassword.text;
      _formKey.currentState!.save();

      print("Success");
      print('$_name');
      print('$_emailID');
      print('$_pass');
      print('$_confirmPass');
    } else {
      print("Unsuccessful");
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
                    _validateForm();
                    try {
                      await authenticate.emailPassword(_emailID, _pass);
                      authenticate.storeData(_name, _emailID, _pass);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );

                    } catch (e) {
                      print(e.toString());
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
