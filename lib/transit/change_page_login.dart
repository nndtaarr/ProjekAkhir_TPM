import 'package:flutter/material.dart';
import '../LoginRegisterPage/login_page.dart';

class ChangePageLogin extends StatefulWidget {
  const ChangePageLogin({Key? key}) : super(key: key);

  @override
  State<ChangePageLogin> createState() => _ChangePageLoginState();
}

class _ChangePageLoginState extends State<ChangePageLogin> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: const LoginPage(),
    );
  }

}