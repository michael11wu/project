class Account {
  int? _id;
  String? _account;
  String? _payment;

  Account(this._account, this._payment);
  Account.withID(this._id, this._account, this._payment);

  int? get id => _id;

  String? get account => _account;

  String? get payment => _payment;

  set payment(String? newPayment) {
    if (newPayment == null) {
      return;
    }
    if (newPayment.length <= 255) {
      this._payment = newPayment;
    }
  }

  set account(String? newAccount) {
    if (newAccount == null) {
      return;
    } else {
      this._account = newAccount;
    }
  }

  //convert to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["id"] = _id;
    }
    map['account'] = _account;
    map['payment'] = _payment;

    return map;
  }

  //extract from map object
  Account.fromMapObject(dynamic map) {
    this._id = map['id'];
    this._payment = map['payment'];
    this._account = map['account'];
  }
}
