import 'package:flutter/material.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loader'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Loading....'
        ),
      ),
    );
  }
}
