import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tools/components/my_button.dart';
import '../../tools/components/my_textfield.dart';
import '../../view_model/auth_view_model/login_or_register_page_view_model.dart';
import '../../view_model/auth_view_model/login_page_view_model.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    LoginPageViewModel viewModel = Provider.of(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon
          Icon(
            Icons.store_mall_directory,
            size: 120,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(
            height: 10,
          ),

          // logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Image.asset(
              "assets/logo.png",
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          MyTextField(
            controller: viewModel.emailController,
            obscureValue: false,
            hintText: "Input email",
          ),

          const SizedBox(
            height: 25,
          ),

          MyTextField(
            controller: viewModel.passwordController,
            obscureValue: true,
            hintText: "Input password",
          ),

          const SizedBox(
            height: 25,
          ),

          MyButton(
            text: "LOGIN",
            func: () => viewModel.login(context),
          ),

          const SizedBox(
            height: 25,
          ),

          // register-now part
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not a member?",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                  onTap: () {
                    context.read<LoginOrRegisterPageViewModel>().togglePages(
                        context
                            .read<LoginOrRegisterPageViewModel>()
                            .isLoginPage);
                  },
                  child: Text(
                    " Register now",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
