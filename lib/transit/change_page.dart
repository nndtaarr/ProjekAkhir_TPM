import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projek_tpm/helper/hive_database_user.dart';
import 'package:projek_tpm/view/bottom_nav.dart';

class ChangePageHome extends StatefulWidget {
  final String user;
  const ChangePageHome({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangePageHome> createState() => _ChangePageHomeState();
}

class _ChangePageHomeState extends State<ChangePageHome> {
  bool isLoading = true;
  late final HiveDatabase hive = HiveDatabase();
  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String? history = _hive.getHistory(widget.user);
    // String? images = _hive.getImage(widget.user);
    return isLoading == true
        ? Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()))
        : BottomNav(username: widget.user);
    // HomePage(username: widget.user);
  }
}
