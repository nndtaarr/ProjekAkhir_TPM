import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projek_tpm/helper/hive_database_fav.dart';
import 'package:projek_tpm/helper/hive_database_recipe.dart';
import 'package:projek_tpm/helper/shared_preference.dart';
import 'package:projek_tpm/hive_model/data_model.dart';
import 'package:projek_tpm/model/meal_detail_model.dart';
import 'package:projek_tpm/model/meal_list_model.dart';
import 'package:projek_tpm/source/meal_source.dart';
import 'package:projek_tpm/view/bottom_nav.dart';
import 'package:projek_tpm/view/meal_category.dart';

import '../main.dart';
import 'home_page.dart';
import 'meal_list_page.dart';

class MyRecipeDetailPage extends StatefulWidget {
  final List<dynamic> list;
  final int index;
  const MyRecipeDetailPage({Key? key, required this.list, required this.index})
      : super(key: key);

  @override
  State<MyRecipeDetailPage> createState() => _MyRecipeDetailPageState();
}

class _MyRecipeDetailPageState extends State<MyRecipeDetailPage> {
  final HiveDatabaseRecipe _hiveFav = HiveDatabaseRecipe();
  late int index = widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of ${widget.list[index].nameMeal}".toTitleCase()),
        actions: [
          IconButton(
            onPressed: () async {
              String username = await SharedPreference.getUsername();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNav(
                          username: username,
                        )),
                (_) => false,
              );
            },
            icon: const Icon(Icons.home),
            iconSize: 30,
          )
        ],
      ),
      body: _buildDetailMeal(),
    );
  }

  Widget _buildDetailMeal() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildHeader(),
            _buildDescription(),
            _buildIngredient(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 5.0, color: Colors.teal),
          borderRadius: BorderRadius.circular(25),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: widget.list[index].imageMeal == ""
                    ? const CircleAvatar(
                        radius: 65.0,
                        child: Center(child: Text("NO IMAGE")),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 65,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: Image.file(
                            File("${widget.list[index].imageMeal}"),
                            fit: BoxFit.cover,
                          ).image,
                        ),
                      ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200.0,
              height: 140.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "${widget.list[index].nameMeal}".toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 9),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 5.0, color: Colors.redAccent),
          borderRadius: BorderRadius.circular(20),
          color: Colors.redAccent.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "INSTRUCTIONS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Text(
                "${widget.list[index].insMeal}",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredient() {
    List<String> value = [
      "${widget.list[index].ingMeal1}",
      "${widget.list[index].ingMeal3}",
      "${widget.list[index].ingMeal2}"
    ];
    debugPrint("${widget.list[index].ingMeal1}");

    int i = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.redAccent,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(15),
          color: Colors.redAccent.withOpacity(0.7),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Text(
                "MAIN INGREDIENTS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20.0,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, i) {
                  return Card(
                      color: Colors.teal.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MealListPage(value: value[i], index: 2);
                          }));
                        },
                        splashColor: Colors.lightBlueAccent,
                        highlightColor: Colors.lightBlueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.network(
                                  "https://www.themealdb.com/images/ingredients/${value[i]}-Small.png",
                                  width: 100.0, errorBuilder:
                                      (BuildContext context, Object exception,
                                          StackTrace? stackTrace) {
                                return Text("No Image");
                              }),
                              Text(
                                value[i].toTitleCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
                itemCount: value.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//
// var data =
// (await GithubDataSource.instance.loadUsersData(_search));
