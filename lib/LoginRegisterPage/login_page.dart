import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projek_tpm/LoginRegisterPage/register_page.dart';
import 'package:projek_tpm/helper/common_submit_button.dart';
import 'package:projek_tpm/helper/hive_database_user.dart';
import 'package:projek_tpm/helper/shared_preference.dart';

import 'package:projek_tpm/view/bottom_nav.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        print('Form is valid');
      } else {
        print('Form is invalid');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Container(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image(
                      image: Image.asset(
                        'assets/images/logo1.png',
                      ).image,
                    ),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.deepOrange),
                      labelText: "  Username",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.green),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.green),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Username cannot be blank' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.deepOrange),
                      label: Text("  Password"),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.green),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.green),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Password cannot be blank' : null,
                  ),
                ),
                SizedBox(height: 20),
                _buildLoginButton(),
                Center(
                  child: Text(
                    "\nDidn't Have an Account ?",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontFamily: 'OpenSans'),
                  ),
                ),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 250,
            child: ElevatedButton(
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white.withOpacity(.7)),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                minimumSize: Size(10, 40),
              ),
              onPressed: () {
                validateAndSave();
                String currentUsername = _usernameController.value.text;
                String currentPassword = _passwordController.value.text;

                _processLogin(currentUsername, currentPassword);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Container(
          width: 250,
          child: ElevatedButton(
            child: Text(
              "Register",
              style: TextStyle(color: Colors.white.withOpacity(.7)),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              minimumSize: Size(10, 40),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  void _processLogin(String username, String password) async {
    final HiveDatabase _hive = HiveDatabase();
    bool found = false;
    var key = utf8.encode(password);
    var digest = sha1.convert(key);
    password = digest.toString();

    found = _hive.checkLogin(username, password);
    if (!found) {
      _showToast("Akun Tidak Ada",
          duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    } else {
      SharedPreference().setLogin(username, password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          // builder: (context) => HomePage(username:username),
          builder: (context) => BottomNav(username: username),
        ),
      );
    }
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}) {
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }
}
