import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:finance_app/models/funds.dart';
import 'package:finance_app/utils/db_helper.dart';

class Settings extends StatefulWidget {
  final List<dynamic> defaults;
  final List<String> accounts;

  Settings(this.defaults, this.accounts);
  @override
  State<StatefulWidget> createState() =>
      SettingsState(this.defaults, this.accounts);
}

class SettingsState extends State<Settings> {
  List<dynamic> defaults;
  List<String> accounts;

  SettingsState(this.defaults, this.accounts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: Text("Settings")
      ),
      body: (Text("Hello")) 
    );
  }
}
