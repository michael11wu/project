import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:finance_app/models/funds.dart';
import 'package:finance_app/utils/db_helper.dart';
import './settings.dart';

class AddTransaction extends StatefulWidget {
  final String? barTitle;
  final Funds fund;
  final List<String> account;

  AddTransaction(this.fund, this.account, this.barTitle);

  @override
  State<StatefulWidget> createState() =>
      _AddTransactionState(this.fund, this.account, this.barTitle);
}

class _AddTransactionState extends State<AddTransaction> {
  String? barTitle;
  Funds fund;
  List<String> account;
  int count = 5;
  _AddTransactionState(this.fund, this.account, this.barTitle);

  DbHelper dbHelper = DbHelper();

  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController accountController = TextEditingController();

  final List<String?> _types = [
    'Grocery',
    'Utilities',
    'Rent',
    'Entertainment'
  ];

  //drop down menus
  String? _type = 'Grocery';
  String _account = '';

  //defaults
  String defaulttype = 'Grocery';
  String defaultaccount = '';
  List<dynamic> defaults = [];

  DateTime now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    String formattedDate = formatter.format(now);
    dateController.text = formattedDate;

    if (this.barTitle == 'Edit Transaction') {
      //update for edit transaction
      dateController.text = fund.date.toString();
      descriptionController.text = fund.description.toString();
      amountController.text = fund.amount.toString();
      accountController.text = fund.account.toString();
      this._type = typeAsString(fund.type).toString();
    }

    initState() {

    }

    //update defaults
    typeAsInt(_type);
    updateDate();
    this._account = account[0];
    updateAccount();


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            movetoLastScreen();
          },
        ),
        backgroundColor: Colors.greenAccent,
        title: Text(barTitle!, style: TextStyle(color: Colors.grey.shade800)),
      ),
      backgroundColor: Colors.grey.shade400,
      body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: TextField(
                  controller: amountController,
                  onChanged: (value) {
                    updateAmount();
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade500,
                      filled: true,
                      labelText: 'Amount in Dollars',
                      hintText: 'e.g. 12.42',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                  keyboardType: TextInputType.number,
                )),
            Padding(
                padding: EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: TextField(
                  controller: descriptionController,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade500,
                      filled: true,
                      labelText: 'Description',
                      hintText: 'e.g. Cold Stone',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                  keyboardType: TextInputType.text,
                )),
            Padding(
                padding: EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: TextField(
                  controller: dateController,
                  onChanged: (value) {
                    updateDate();
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade500,
                      filled: true,
                      labelText: 'Date',
                      hintText: 'e.g. 2001-02-07',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                  keyboardType: TextInputType.number,
                )),
            Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(right: 1, left: 1, top: 5, bottom: 5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButton<String>(
                        items: account.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        dropdownColor: Colors.greenAccent,
                        elevation: 24,
                        value: _account,
                        onChanged: (value) {
                          setState(() {
                            this._account = value!;
                            updateAccount();
                          });
                        }),
                  ),
                  Container(width: 30.0),
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButton<String>(
                        items: _types.map((String? value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value!));
                        }).toList(),
                        dropdownColor: Colors.greenAccent,
                        elevation: 24,
                        value: _type,
                        onChanged: (value) {
                          setState(() {
                            typeAsInt(value);
                            this._type = value;
                          });
                        }),
                  )
                ])),
            Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button");
                              _save();
                            });
                          })),
                  Container(width: 30),
                  Expanded(
                      child: ElevatedButton(
                          child: Text(
                            'Reset',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _reset();
                            });
                          })),
                ])),
          ])),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Settings',
        child: Icon(Icons.settings_applications_sharp),
        onPressed: () {
          defaults.add(defaultaccount);
          defaults.add(defaulttype);
          //navigateToSettings();
        },
      ),
    );
  }

  void _reset() {
    dateController.text = '';
    descriptionController.text = '';
    amountController.text = '';
    this._type = defaulttype;
    accountController.text = '';
  }

  void movetoLastScreen() {
    Navigator.pop(context, true);
  }

  void navigateToSettings() async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => Settings(defaults, account)));
    if (result == true) {}
  }

  void typeAsInt(String? value) {
    switch (value) {
      case 'Grocery':
        fund.type = 1;
        break;
      case 'Utilities':
        fund.type = 2;
        break;
      case 'Rent':
        fund.type = 3;
        break;
      case 'Entertainment':
        fund.type = 4;
        break;
    }
  }

  String typeAsString(int? value) {
    String typeType = '';
    switch (value) {
      case 1:
        typeType = 'Grocery';
        break;
      case 2:
        typeType = 'Utilities';
        break;
      case 3:
        typeType = 'Rent';
        break;
      case 4:
        typeType = 'Entertainment';
        break;
    }
    return typeType;
  }

  void setPaymentAccount() {}

  void updateAccount() {
    fund.account = this._account;
  }

  void updateAmount() {
    fund.amount = double.parse(amountController.text);
  }

  void updateDate() {
    fund.date = dateController.text;
  }

  void updateDescription() {
    fund.description = descriptionController.text;
  }

  void _save() async {
    movetoLastScreen();
    int result;
    if (fund.id != null) {
      result = await dbHelper.updateFund(fund);
    } else {
      result = await dbHelper.insertFund(fund);
    }

    if (result != 0) {
      _showAlert("Status", "Success");
    } else {
      _showAlert("Status", "Failure");
    }
  }

  void _showAlert(String title, String message) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(message));
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
