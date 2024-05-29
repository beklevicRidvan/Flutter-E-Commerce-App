import 'package:firestore_ecommerce_app/model/user_model.dart';
import 'package:flutter/material.dart';

import '../../repository/database_repository.dart';
import '../../tools/locator.dart';

class LoginPageViewModel with ChangeNotifier{
  late TextEditingController _emailController;
  late TextEditingController _passwordController;



  final _repository = locator<DatabaseRepository>();


  LoginPageViewModel(){
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }


  void login(BuildContext context)async{
    try{
      UserModel userModel = UserModel(userEmail: _emailController.text);
      await _repository.signInWithEmailAndPassword(_emailController.text, _passwordController.text, userModel);
      _emailController.clear();
      _passwordController.clear();
    }
    catch(e){
      showDialog(context: context, builder: (context) {
        return AlertDialog(title: Text(e.toString()),);
      },);
    }
  }


  TextEditingController get passwordController => _passwordController;

  TextEditingController get emailController => _emailController;
}