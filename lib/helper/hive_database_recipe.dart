import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek_tpm/hive_model/data_model.dart';

class HiveDatabaseRecipe {
  late Box<MyRecipeModel> _localDB = Hive.box<MyRecipeModel>("recipe");

  void addData(MyRecipeModel data) {
    _localDB.add(data);
  }

  void deleteData(String? name, String? nameMeal) {
    for (int i = 0; i < getLengthAll(); i++) {
      if (name == _localDB.getAt(i)!.name &&
          nameMeal == _localDB.getAt(i)!.nameMeal) {
        _localDB.deleteAt(i);
        break;
      }
    }
  }

  void showAll() {
    for (int i = 0; i < getLengthAll(); i++) {
      debugPrint("${_localDB.getAt(i)!.name}");
    }
  }

  int getLength(String? username) {
    var filteredUsers =
        _localDB.values.where((_localDB) => _localDB.name == username).toList();
    return filteredUsers.length;
  }

  int getLengthAll() {
    return _localDB.length;
  }

  List values() {
    List values = _localDB.values.toList();
    return values;
  }

  ValueListenable<Box<MyRecipeModel>> listenable() {
    return _localDB.listenable();
  }
}
