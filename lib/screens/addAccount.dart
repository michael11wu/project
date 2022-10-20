import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:finance_app/models/account.dart';
import 'package:finance_app/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class Accounts extends StatefulWidget {
  final Account account;
  final String? barTitle;

  Accounts(this.account, this.barTitle);

  @override
  State<StatefulWidget> createState() =>
      _AccountsState(this.account, this.barTitle);
}

class _AccountsState extends State<Accounts> {
  List<Account>? accountList;
  Account account;
  String? barTitle;
  _AccountsState(this.account, this.barTitle);
  int? count = 5;

  List<String?> payments = ['Cash', 'Debit', 'Credit'];
  String? payment = 'Cash';

  DbHelper dbHelper = DbHelper();

  TextEditingController accountController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    updatePayment();

    if (accountList == null) {
      accountList = List<Account>.empty(growable: true);
      updateListAccount();
    }

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
        body: Column(children: <Widget>[
          Expanded(child: getAllAccounts()),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(children: <Widget>[
              Expanded(
                child: TextField(
                  controller: accountController,
                  onChanged: (value) {
                    updateAccountNum();
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade500,
                      filled: true,
                      labelText: "Add Account Num.",
                      hintText: "e.g. TCF 4343",
                      labelStyle: Theme.of(context).textTheme.headline6,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                width: 5,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButton<String>(
                      items: payments.map((String? value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value!));
                      }).toList(),
                      dropdownColor: Colors.greenAccent,
                      elevation: 24,
                      value: payment,
                      onChanged: (value) {
                        setState(() {
                          this.payment = value;
                          updatePayment();
                        });
                      },
                    )),
              )
            ]),
          ),
          Container(
              width: 100,
              child: ElevatedButton(
                child: Text("Save"),
                onPressed: () {
                  setState(() {
                    _save();
                  });
                },
              )),
        ]));
  }

  ListView getAllAccounts() {
    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          if (this.accountList!.length != 0) {
            return Card(
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade500,
              elevation: 7.5,
              shadowColor: Colors.greenAccent,
              child: ListTile(
                title: Text(
                  this.accountList![position].account.toString(),
                  style: titleStyle,
                ),
                subtitle: Text(
                  this.accountList![position].payment.toString(),
                ),
                trailing: GestureDetector(
                    child: Icon(Icons.delete, color: Colors.greenAccent),
                    onTap: () {
                      _showAlertDelete(position);
                    }),
                // onTap: () {
                //   navigateToInfo(this.fundList![position], accountList,
                //       'Edit Transaction');
                // }
              ),
            );
          } else {
            return Card();
          }
        });
  }

  void updateAccountNum() {
    account.account = (accountController.text);
  }

  void updatePayment() {
    account.payment = payment;
  }

  void movetoLastScreen() {
    Navigator.pop(context, true);
  }

  void _showAlert(String title, String message) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(message));
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }

  void _showAlertDelete(int position) {
    Widget cancelButton = TextButton(
      child: Text(
        'Cancel',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        'Continue',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        _delete(context, accountList![position]);
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Are you sure you want to delete?"),
      actions: [continueButton, cancelButton],
    );
    showDialog(
      context: context,
      builder: (_) => alert,
    );
  }

  void _save() async {
    movetoLastScreen();
    int result;
    if (account.id != null) {
      result = await dbHelper.updateAccount(account);
    } else {
      result = await dbHelper.insertAccount(account);
    }

    if (result != 0) {
      _showAlert("Status", "Success");
    } else {
      _showAlert("Status", "Failure");
    }
  }

  void _snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 100), content: Text(message)));
  }

  void _delete(BuildContext context, Account account) async {
    int result = await dbHelper.deleteAccount(account.id);
    if (result != 0) {
      _snackBar(context, 'Account Deleted');
      updateListAccount();
    }
  }

  void updateListAccount() {
    final Future<Database> dbFuture = dbHelper.initializeDb();
    dbFuture.then((database) {
      Future<List<Account>> accountListFuture = dbHelper.getAccountList();
      accountListFuture.then((accountList) {
        setState(() {
          this.accountList = accountList;
          this.count = accountList.length;
        });
      });
    });
  }
}
