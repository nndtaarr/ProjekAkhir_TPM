import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projek_tpm/helper/hive_database_fav.dart';
import 'package:projek_tpm/helper/hive_database_recipe.dart';
import 'package:projek_tpm/helper/shared_preference.dart';
import 'package:projek_tpm/view/bottom_nav.dart';
import 'package:projek_tpm/view/create_recipe_page.dart';
import 'package:projek_tpm/view/meal_category.dart';
import 'package:projek_tpm/view/recipe_detail_page.dart';
import 'favorite_detail_page.dart';
import 'home_page.dart';

class MyRecipePage extends StatefulWidget {
  final String name;
  const MyRecipePage({Key? key, required this.name}) : super(key: key);

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  final HiveDatabaseRecipe _hiveRec = HiveDatabaseRecipe();
  late String name = widget.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Own Recipes"),
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
      body: _buildList(),
    );
  }

  Widget _buildList() {
    int check = _hiveRec.getLength(widget.name);
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              height: 100,
              width: 400,
              padding: EdgeInsets.all(8),
              child: ElevatedButton.icon(
                onPressed: () {
                  SharedPreference().setImage("");
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CreateRecipe(username: name);
                  }));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30.0,
                ),
                label: const Text("Add Recipe"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 600,
            child: ValueListenableBuilder(
              valueListenable: _hiveRec.listenable(),
              builder:
                  (BuildContext context, Box<dynamic> value, Widget? child) {
                if (value.isEmpty || check == 0) {
                  return const Center(
                    child: Text("Data Kosong"),
                  );
                }
                debugPrint(widget.name);
                return _buildSuccessSection(_hiveRec);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessSection(HiveDatabaseRecipe _hiveRec) {
    // debugPrint("${_hiveRec.getLength(widget.name)}");
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: _hiveRec.getLength(widget.name),
          itemBuilder: (BuildContext context, int index) {
            List filteredUsers = _hiveRec
                .values()
                .where((_localDB) => _localDB.name == widget.name)
                .toList();
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.deepOrange.withOpacity(0.7),
                  ),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return MyRecipeDetailPage(
                              list: filteredUsers, index: index);
                        }));
                      },
                      child: _buildItemList(filteredUsers, index))),
            );
          }),
    );
  }

  Widget _buildItemList(List filteredUsers, int index) {
    var text = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.deepOrange.shade600.withOpacity(0.6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: filteredUsers[index].imageMeal == ""
                      ? CircleAvatar(
                          radius: 65.0,
                          child: Center(child: Text("NO IMAGE")),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.file(
                            File("${filteredUsers[index].imageMeal}"),
                            width: 120.0,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text("${filteredUsers[index].nameMeal}".toTitleCase(),
                style: const TextStyle(fontSize: 25.0)),
          )),
          Center(
            child: Container(
              width: 100,
              child: InkWell(
                onTap: () {
                  _hiveRec.deleteData(name, "${filteredUsers[index].nameMeal}");
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.red.shade600,
                  size: 40.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
    return text;
  }
}
