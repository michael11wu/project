import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import './addTransaction.dart';
import 'dart:async';
import 'package:finance_app/models/funds.dart';
import 'package:finance_app/models/account.dart';
import 'package:finance_app/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import './addAccount.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  DbHelper dbHelper = DbHelper();
  List<Account>? accountList;
  List<Funds>? fundList;
  int? count = 5;

  List<String> accounts = List<String>.empty(growable: true);

  String _param = ''; //param to send when filtering
  String _pvalue = ''; //value to send when filtering

  @override
  Widget build(BuildContext context) {
    if (fundList == null) {
      //create fundList if not created
      fundList = List<Funds>.empty(growable: true);
      updateListView();
    }
    if (accountList == null) {
      //create accountList if not created
      accountList = List<Account>.empty(growable: true);
      updateListAccount();
    }

    if (accountList!.length == 0) {
      //Add account if there isn't any present
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Center(
                child: Text("TrackFunds",
                    style: TextStyle(color: Colors.grey.shade800))),
          ),
          backgroundColor: Colors.grey.shade400,
          body: Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 200,
                        child: ElevatedButton(
                          child: Text('Please Add Account to Start'),
                          onPressed: () {
                            navigateToAccount(Account('', ''), "Add Account");
                          },
                        ))
                  ])));
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Center(
              child: Text("TrackFunds",
                  style: TextStyle(color: Colors.grey.shade800))),
        ),
        backgroundColor: Colors.grey.shade400,
        body: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              Expanded(child: getLastTransactions()),
              Container(
                  child: Row(children: <Widget>[
                Expanded(
                    child: IconButton(
                        icon: Icon(Icons.playlist_add_rounded,
                            color: Colors.grey.shade800, size: 30),
                        splashColor: Colors.greenAccent,
                        tooltip: 'Add',
                        onPressed: () {
                          //updateListAccount();
                          buildAccountString();
                          navigateToInfo(Funds('', 0, '', 0, 0, ''), accounts,
                              "Add Transaction"); //date, amount, account, payment type, balance, expense type
                        })),
                Container(width: 5.0),
                Expanded(
                    child: IconButton(
                        icon: Icon(Icons.search_rounded,
                            color: Colors.grey.shade800, size: 30),
                        splashColor: Colors.greenAccent,
                        tooltip: 'Lookup',
                        onPressed: () {
                          _showFilterAlert();
                        })),
                Container(width: 5.0),
                Expanded(
                    child: IconButton(
                        icon: Icon(Icons.restore_page_outlined,
                            color: Colors.grey.shade800, size: 30.0),
                        splashColor: Colors.greenAccent,
                        tooltip: 'Restore List',
                        onPressed: () {
                          updateListView();
                        })),
                Container(width: 5.0),
                Expanded(
                    child: IconButton(
                        icon: Icon(Icons.account_balance_wallet_rounded,
                            color: Colors.grey.shade800, size: 30.0),
                        splashColor: Colors.greenAccent,
                        tooltip: 'Add Account',
                        onPressed: () {
                          navigateToAccount(Account('', ''), "Add Account");
                        })),
              ])),
            ])),
      );
    }
  }

  ListView getLastTransactions() {
    //List all the transactions
    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          if (this.fundList!.length != 0) {
            return Card(
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade500,
              elevation: 7.5,
              shadowColor: Colors.greenAccent,
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade900,
                    foregroundColor:
                        getAccountColor(this.fundList![position].type),
                    child: getAccountIcon(this.fundList![position].type),
                  ),
                  title: Text(
                    this.fundList![position].amount.toString(),
                    style: titleStyle,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Date: ' + this.fundList![position].date.toString(),
                      ),
                      Text(
                        this.fundList![position].account.toString(),
                      ),
                    ],
                  ),
                  trailing: GestureDetector(
                      child: Icon(Icons.delete, color: Colors.greenAccent),
                      onTap: () {
                        _showAlert(position);
                      }),
                  onTap: () {
                    buildAccountString();
                    navigateToInfo(
                        this.fundList![position], accounts, 'Edit Transaction');
                  }),
            );
          } else {
            return Card();
          }
        });
  }

  void _delete(BuildContext context, Funds fund) async {
    int result = await dbHelper.deleteFund(fund.id);
    if (result != 0) {
      _snackBar(context, 'Fund Deleted');
      updateListView();
    }
  }

  void _snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 100), content: Text(message)));
  }

  void navigateToInfo(Funds fund, List<String> account, String? bar) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddTransaction(fund, account, bar)));
    if (result == true) {
      updateListView();
    }
  }

  void navigateToAccount(Account account, String? bar) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => Accounts(account, bar)));
    if (result == true) {
      debugPrint("Hello");
      updateListAccount();
      buildAccountString();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDb();
    dbFuture.then((database) {
      Future<List<Funds>> fundListFuture = dbHelper.getFundList();
      fundListFuture.then((fundList) {
        setState(() {
          this.fundList = fundList;
          this.count = fundList.length;
        });
      });
    });
  }

  void updateListAccount() {
    final Future<Database> dbFuture = dbHelper.initializeDb();
    dbFuture.then((database) {
      Future<List<Account>> accountListFuture = dbHelper.getAccountList();
      accountListFuture.then((accountList) {
        setState(() {
          this.accountList = accountList;
        });
      });
    });
  }

  void updateListViewFilter(String col, String value) {
    final Future<Database> dbFuture = dbHelper.initializeDb();
    dbFuture.then((database) {
      Future<List<Funds>> fundListFuture =
          dbHelper.getFundListFilter(col, value);
      fundListFuture.then((fundList) {
        setState(() {
          this.fundList = fundList;
          this.count = fundList.length;
        });
      });
    });
  }

  void _showAlert(int position) {
    //alert when deleting a transaction
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
        _delete(context, fundList![position]);
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

  void _showFilterAlert() {
    //alert to get parameter and parameter value to filter
    TextEditingController valueController = new TextEditingController();
    TextEditingController paramController = new TextEditingController();

    Widget parameterButton = Container(
        margin: EdgeInsets.all(5),
        child: TextField(
          controller: paramController,
          onChanged: (value) {
            this._param = value;
          },
          decoration: InputDecoration(
              fillColor: Colors.grey.shade500,
              filled: true,
              labelText: 'Parameter',
              hintText: 'e.g. Type',
              labelStyle: Theme.of(context).textTheme.headline6,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0))),
        ));
    Widget valueButton = TextField(
      controller: valueController,
      onChanged: (value) {
        if (_param == 'Type') value = typeAsInt(value);
        if (_param == 'Payment' || _param == 'Date' || _param == 'Description')
          value = "'" + value + "'";
        setState(() {
          this._pvalue = value;
        });
      },
      decoration: InputDecoration(
          fillColor: Colors.grey.shade500,
          filled: true,
          labelText: 'Specified Value',
          hintText: 'e.g. Grocery',
          labelStyle: Theme.of(context).textTheme.headline6,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))),
    );
    Widget continueButton = TextButton(
      child: Text(
        'Continue',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        updateListViewFilter(_param, _pvalue);
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Select Parameter/Value"),
      content: Text(
          "Parameter can be: Date, Account, Description, Payment, Type, Amount"),
      actions: [parameterButton, valueButton, continueButton],
    );
    showDialog(
      context: context,
      builder: (_) => alert,
    );
  }

  String typeAsInt(String? value) {
    String result = '';
    switch (value) {
      case 'Grocery':
        result = '1';
        return result;
      case 'Utilities':
        result = '2';
        return result;
      case 'Rent':
        result = '3';
        return result;
      case 'Entertainment':
        result = '4';
        return result;
    }
    return result;
  }

  Color getAccountColor(int? type) {
    switch (type) {
      case 1:
        return Colors.redAccent.shade400;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.cyanAccent;
      case 4:
        return Colors.deepPurpleAccent.shade700;
      default:
        return Colors.grey;
    }
  }

  Icon getAccountIcon(int? type) {
    switch (type) {
      case 1:
        return Icon(Icons.local_grocery_store_rounded);
      case 2:
        return Icon(Icons.bolt_rounded);
      case 3:
        return Icon(Icons.house_rounded);
      case 4:
        return Icon(Icons.movie_creation_rounded);
      default:
        return Icon(Icons.local_grocery_store_rounded);
    }
  }

  void buildAccountString() {
    accounts = List<String>.empty(growable: true);
    for (int i = 0; i < this.accountList!.length; i++) {
      this.accounts.add(accountList![i].account!);
    }
  }
}
