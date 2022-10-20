import 'package:flutter/material.dart';
import './screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackFund',
      debugShowCheckedModeBanner: false,
      theme: ThemeData (
        appBarTheme: AppBarTheme (
          iconTheme: IconThemeData(color: Colors.grey.shade800),
        ),
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        primarySwatch: colorCustom,
        ),
      home: HomeScreen()
    );
  }

}

Map<int, Color> color = {
  50: Color.fromRGBO(105, 240, 174, .1),
  100: Color.fromRGBO(105, 240, 174, .2),
  200: Color.fromRGBO(105, 240, 174, .3),
  300: Color.fromRGBO(105, 240, 174, .4),
  400: Color.fromRGBO(105, 240, 174, .5),
  500: Color.fromRGBO(105, 240, 174, .6),
  600: Color.fromRGBO(105, 240, 174, .7),
  700: Color.fromRGBO(105, 240, 174, .8),
  800: Color.fromRGBO(105, 240, 174, .9),
  900: Color.fromRGBO(105, 240, 174, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF69F0AE, color);