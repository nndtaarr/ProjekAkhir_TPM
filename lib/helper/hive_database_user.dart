import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek_tpm/hive_model/data_model.dart';

class HiveDatabase {
  final Box<UserAccountModel> _localDB = Hive.box<UserAccountModel>("account");

  void addData(UserAccountModel data) {
    _localDB.add(data);
  }

  int getLength() {
    return _localDB.length;
  }

  bool checkLogin(String username, String password) {
    bool found = false;
    for (int i = 0; i < getLength(); i++) {
      if (username == _localDB.getAt(i)!.username &&
          password == _localDB.getAt(i)!.password) {
        ("Login Success");
        found = true;
        break;
      } else {
        found = false;
      }
    }

    return found;
  }

  bool checkUsers(String username) {
    bool found = false;
    for (int i = 0; i < getLength(); i++) {
      if (username == _localDB.getAt(i)!.username) {
        found = true;
        break;
      } else {
        found = false;
      }
    }
    return found;
  }
}
