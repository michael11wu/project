import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:finance_app/models/funds.dart';
import 'package:finance_app/models/account.dart';

class DbHelper {
  static DbHelper? _dbHelper; //singleton dbhlper
  static Database? _db; //singleton Db

  String fundTable = 'fund_table';
  String colId = 'id';
  String colAccount = 'account';
  String colAmount = 'amount';
  String colBalance = 'balance';
  String colDescription = 'description';
  String colDate = 'date';
  String colType = 'type';

  DbHelper._createInstance();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createInstance();
    }
    return _dbHelper!;
  }

  Future<Database> get database async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db!;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'funds.db';

    var fundsDB = await openDatabase(path, version: 1, onCreate: _createDb);
    return fundsDB;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $fundTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount REAL, $colAccount INTEGER, $colBalance REAL, $colDescription TEXT, $colDate TEXT, $colType INTEGER)');
    await db.execute('CREATE TABLE account (id INTEGER PRIMARY KEY AUTOINCREMENT, account INTEGER, payment TEXT)');
  }

  Future<List<Map<String, dynamic>>> getFundMapList() async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM $fundTable order by $colType ASC');
    //var result = await db.query(fundtable, orderBy: '$colAmount ASC')
    return result;
  }

  Future<List<Map<String, dynamic>>> getAccountMapList() async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM account order by id ASC');
    //var result = await db.query(fundtable, orderBy: '$colAmount ASC')
    return result;
  }

  Future<List<Map<String, dynamic>>> getFundMapListFilter(String col, String val) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM $fundTable WHERE $col = $val');
    //var result = await db.query(fundtable, orderBy: '$colAmount ASC')
    return result;
  }

  Future<int> insertFund(Funds fund) async {
    Database db = await this.database;
    //var result = await db.rawQuery('INSERT INTO $fundTable')
    var result1 = await db.insert(fundTable, fund.toMap());
    return result1;
  }

  Future<int> deleteFund(int? id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $fundTable WHERE $colId = $id');
    return result;
  }

  Future<int> insertAccount(Account account) async {
    Database db = await this.database;
    //var result = await db.rawQuery('INSERT INTO $fundTable')
    var result1 = await db.insert('account', account.toMap());
    return result1;
  }

  Future<int> deleteAccount(int? id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM account WHERE id = $id');
    return result;
  }

  Future<int> updateFund(Funds fund) async {
    Database db = await this.database;
    var result = await db.update(fundTable, fund.toMap(),
        where: '$colId = ?', whereArgs: [fund.id]);
    return result;
  }

  Future<int> updateAccount(Account account) async {
    Database db = await this.database;
    var result = await db.update('account', account.toMap(),
        where: '$colId = ?', whereArgs: [account.id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $fundTable');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  Future<int> getAccountCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from account');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

//get 'map lsit' and convert to fund list
  Future<List<Funds>> getFundList() async {
    var fundMapList = await getFundMapList();
    int count = fundMapList.length;

    List<Funds> fundList = [];

    for (int i = 0; i < count; i++) {
      fundList.add(Funds.fromMapObject(fundMapList[i]));
    }

    return fundList;
  }

  Future<List<Account>> getAccountList() async {
    var accountMapList = await getAccountMapList();
    int count = accountMapList.length;

    List<Account> accountList = [];

    for (int i = 0; i < count; i++) {
      accountList.add(Account.fromMapObject(accountMapList[i]));
    }

    return accountList;
  }

  Future<List<Funds>> getFundListFilter(String col, var val) async {
    var fundMapList = await getFundMapListFilter(col, val);
    int count = fundMapList.length;

    List<Funds> fundList = [];

    for (int i = 0; i < count; i++) {
      fundList.add(Funds.fromMapObject(fundMapList[i]));
    }

    return fundList;
  }
}
