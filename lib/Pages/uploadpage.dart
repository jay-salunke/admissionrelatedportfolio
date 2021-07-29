import 'package:flutter/material.dart';
import 'package:admission_portfolio/Pages/signup.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(),
      appBar: AppBar(
        title: Text('Download Files'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
              child: Card(
                color:Colors.grey[900],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Text(
                    'Text1',
                    style: TextStyle(
                      color:Colors.cyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),

                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
