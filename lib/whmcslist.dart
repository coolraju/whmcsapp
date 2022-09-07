import 'dbhelper.dart';

class Whmcslist {
  int? id;
  String? name;
  String? url;
  String? api;
  String? password;
  String? secret;

  Whmcslist(this.id, this.name, this.url, this.api, this.password, this.secret);

  Whmcslist.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    url = map['url'];
    api = map['api'];
    password = map['password'];
    secret = map['secret'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnUrl: url,
      DatabaseHelper.columnApi: api,
      DatabaseHelper.columnPasword: password,
      DatabaseHelper.columnSecret: secret,
    };
  }
}
