import 'package:flutter/material.dart';

class BackendData extends ChangeNotifier {
  String _url = '10.0.2.2:3000';
  String _username = 'root';
  String _password = 'testtest';

  String get url => this._url;
  void updateUrl(String url) {
    this._url = url;
    notifyListeners();
  }

  String get username => this._username;
  void updateUsername(String username) {
    this._username = username;
    notifyListeners();
  }

  String get password => this._password;
  void updatePassword(String password) {
    this._password = password;
  }
}
