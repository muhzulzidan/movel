import 'package:flutter/material.dart';

import 'home/home.dart';

class PesananScreen extends StatefulWidget {
  @override
  _PesananScreenState createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Kotak Masuk",
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Container(
        child: Center(
          child: Text('This is Pesanan'),
        ),
      ),
    );
  }
}
