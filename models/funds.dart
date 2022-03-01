class Funds {
  int? _id;
  String? _account;
  String? _date;
  double? _balance;
  double? _amount;
  int? _type;
  String? _description;

  Funds(this._date, this._amount, this._account, this._balance, this._type,
      [this._description]);
  Funds.withID(this._id, this._date, this._amount, this._account, this._balance,
      this._type,
      [this._description]);

  String? get description => _description;

  int? get id => _id;

  double? get balance => _balance;

  int? get type => _type;

  String? get date => _date;

  double? get amount => _amount;

  String? get account => _account;

  set date(String? newDate) {
    if (newDate == null) {
      return;
    }
    if (newDate.length <= 255) {
      this._date = newDate;
    }
  }

  set description(String? newDescription) {
    if (newDescription == null) {
      return;
    } else if (newDescription.length < 255) {
      this._description = newDescription;
    }
  }

  set account(String? newAccount) {
    if (newAccount == null) {
      return;
    } else if (newAccount.length < 255) {
      this._account = newAccount;
    }
  }

  set id(int? newID) {
    this._id = newID;
  }

  set balance(double? newBalance) {
    this._balance = newBalance;
  }

  set amount(double? newAmount) {
    this._amount = newAmount;
  }

  set type(int? newType) {
    if (newType == null) {
      return;
    } else if (newType >= 1 && newType <= 4) {
      this._type = newType;
    }
  }

  //convert to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["id"] = _id;
    }
    map['account'] = _account;
    map['amount'] = _amount;
    map['balance'] = _balance;
    map['date'] = _date;
    map['description'] = _description;
    map['type'] = _type;

    return map;
  }

  //extract from map object
  Funds.fromMapObject(dynamic map) {
    this._id = map['id'];
    this._amount = map['amount'];
    this._balance = map['balance'];
    this._date = map['date'];
    this._description = map['description'];
    this._type = map['type'];
    this._account = map['account'];
  }
}
