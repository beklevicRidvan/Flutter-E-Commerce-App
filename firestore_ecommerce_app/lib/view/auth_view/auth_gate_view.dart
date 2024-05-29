import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_page_view.dart';
import 'login_or_register_page_view.dart';

class AuthGateView extends StatefulWidget {
  const AuthGateView({super.key});

  @override
  State<AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<AuthGateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePageView();
        } else {
          return const LoginOrRegisterPageView();
        }
      },
    );
  }
}
