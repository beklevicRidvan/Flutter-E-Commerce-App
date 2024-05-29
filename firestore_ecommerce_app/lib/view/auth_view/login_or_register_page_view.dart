import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth_view_model/login_or_register_page_view_model.dart';
import 'login_page_view.dart';
import 'register_page_view.dart';

class LoginOrRegisterPageView extends StatelessWidget {
  const LoginOrRegisterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Consumer<LoginOrRegisterPageViewModel>(builder: (context, value, child) {
      if(value.isLoginPage){
        return const LoginPageView();
      }
      else{
        return const RegisterPageView();
      }
    },);
  }



}
