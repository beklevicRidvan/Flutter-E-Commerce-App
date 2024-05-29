import 'package:firestore_ecommerce_app/model/user_model.dart';
import 'package:flutter/material.dart';

import '../../repository/database_repository.dart';
import '../../tools/locator.dart';

class RegisterPageViewModel with ChangeNotifier {
  late TextEditingController _emailController;
  late TextEditingController _fullNameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;

  final _repository = locator<DatabaseRepository>();

  void register(BuildContext context) async {
    try {
      bool value = _passwordController.text.isNotEmpty && _fullNameController.text.isNotEmpty && _emailController.text.isNotEmpty && _confirmController.text.isNotEmpty;

      if (_passwordController.text == _confirmController.text && value) {
        UserModel userModel = UserModel(userEmail: _emailController.text);
        await _repository.signUpWithEmailAndPassword(
            _emailController.text, _passwordController.text,_fullNameController.text, userModel);
        _emailController.clear();

        _passwordController.clear();
        _confirmController.clear();
        _fullNameController.clear();
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(e.toString()),
          );
        },
      );
    }
  }

  RegisterPageViewModel() {
    _emailController = TextEditingController();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
  }

  TextEditingController get confirmController => _confirmController;

  TextEditingController get passwordController => _passwordController;

  TextEditingController get emailController => _emailController;

  TextEditingController get fullNameController => _fullNameController;
}
