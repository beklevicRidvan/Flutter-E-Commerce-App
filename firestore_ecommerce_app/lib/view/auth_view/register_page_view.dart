import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tools/components/my_button.dart';
import '../../tools/components/my_textfield.dart';
import '../../view_model/auth_view_model/login_or_register_page_view_model.dart';
import '../../view_model/auth_view_model/register_page_view_model.dart';

class RegisterPageView extends StatelessWidget {
  const RegisterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Theme.of(context).colorScheme.background,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    RegisterPageViewModel viewModel = Provider.of(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          // logo
          Icon(
            Icons.store_mall_directory,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
      
          const SizedBox(
            height: 10,
          ),
      
          Text(
            "Let's create an account for you",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 16),
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
      
          MyTextField(controller: viewModel.fullNameController, obscureValue: false, hintText: "Input Fullname"),
      
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
      
          MyTextField(
            controller: viewModel.confirmController,
            obscureValue: true,
            hintText: "Confirm password",
          ),
      
          const SizedBox(
            height: 25,
          ),
      
          MyButton(
            text: "REGISTER",
            func: () => viewModel.register(context),
          ),
      
          const SizedBox(
            height: 25,
          ),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
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
                    " Login now",
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
