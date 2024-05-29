import 'package:flutter/material.dart';

class LoginOrRegisterPageViewModel with ChangeNotifier{
  bool _isLoginPage = true;

  bool get isLoginPage => _isLoginPage;

  void togglePages(bool value){
    _isLoginPage = !value;
    notifyListeners();
  }

}