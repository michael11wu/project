import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: "Welcome to Flutter App",
      home: new Material(
          color: Colors.lightGreen,
          child: Center(
            child: Text(
              "Hello Flutter",
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.black87, fontSize: 40),
            ),
          ))));
}
