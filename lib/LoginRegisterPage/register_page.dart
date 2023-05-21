import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:projek_tpm/helper/common_submit_button.dart';
import 'package:projek_tpm/helper/hive_database_user.dart';
import 'package:projek_tpm/hive_model/data_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final HiveDatabase _hive = HiveDatabase();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isExist = false;

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        // ignore: avoid_print
        print('Form is valid');
      } else {
        // ignore: avoid_print
        print('Form is invalid');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 80,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Image(
                  image: Image.asset(
                    'assets/images/logo1.png',
                  ).image,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 24.0),
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
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24.0),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.deepOrange),
                    label: Text("  Password"),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Password cannot be blank' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _buildRegisterButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
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
                  isExist = _hive.checkUsers(_usernameController.text);
                  if (isExist == false &&
                      _usernameController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    var pass = utf8.encode(_passwordController.text);
                    var digest = sha1.convert(pass);
                    _passwordController.text = digest.toString();
                    print(_passwordController.text);
                    _hive.addData(UserAccountModel(
                      username: _usernameController.text,
                      password: _passwordController.text,
                    ));
                    _usernameController.clear();
                    _passwordController.clear();
                    setState(() {});

                    Navigator.pop(context);
                  } else {
                    _showToast("Akun Sudah Ada",
                        duration: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM);
                  }
                },
              ))
        ],
      ),
    );
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}) {
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }
}
