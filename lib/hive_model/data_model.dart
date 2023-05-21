import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 1)
class MyFavorite {
  MyFavorite(
      {required this.name,
      required this.nameMeal,
      required this.idMeal,
      required this.imageMeal});

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? nameMeal;

  @HiveField(2)
  String? imageMeal;

  @HiveField(3)
  String? idMeal;
}

@HiveType(typeId: 2)
class UserAccountModel {
  UserAccountModel({required this.username, required this.password});

  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @override
  String toString() {
    return 'UserAccountModel{username: $username, password: $password}';
  }
}

@HiveType(typeId: 3)
class MyRecipeModel {
  MyRecipeModel(
      {required this.name,
      required this.nameMeal,
      required this.imageMeal,
      required this.ingMeal1,
      required this.ingMeal2,
      required this.ingMeal3,
      required this.insMeal});

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? nameMeal;

  @HiveField(2)
  String? imageMeal;

  @HiveField(3)
  String? ingMeal1;

  @HiveField(4)
  String? ingMeal2;

  @HiveField(5)
  String? ingMeal3;

  @HiveField(6)
  String? insMeal;
}
