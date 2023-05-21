import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projek_tpm/helper/shared_preference.dart';
import 'package:projek_tpm/model/ingredient_list_model.dart';
import 'package:projek_tpm/source/meal_source.dart';
import 'package:projek_tpm/view/bottom_nav.dart';
import 'package:projek_tpm/view/meal_list_page.dart';

import 'home_page.dart';

class IngredientsListPage extends StatefulWidget {
  const IngredientsListPage({Key? key}) : super(key: key);

  @override
  State<IngredientsListPage> createState() => _IngredientsListPageState();
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class _IngredientsListPageState extends State<IngredientsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredient List"),
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
      body: _buildListIngredient(),
    );
  }

  Widget _buildListIngredient() {
    return FutureBuilder(
        future: MealSource.instance.loadIngredient(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            IngredientList ingredientList =
                IngredientList.fromJson(snapshot.data);
            return _buildSuccessSection(ingredientList);
          }
          return _buildLoadingSection();
        });
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error2");
  }

  Widget _buildSuccessSection(IngredientList data) {
    return ListView.builder(
      padding: EdgeInsets.all(3.0),
      itemCount: data.meals?.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.7),
              ),
              child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MealListPage(
                          value: "${data.meals?[index].strIngredient}",
                          index: 2);
                    }));
                  },
                  child: _buildItemIngredient(
                    "${data.meals?[index].strIngredient}",
                  )),
            ));
      },
    );
  }

  Widget _buildItemIngredient(String value) {
    String imageUrl =
        "https://www.themealdb.com/images/ingredients/$value-Small.png";
    var text = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.red.shade600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    imageUrl,
                    width: 80.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(value.toTitleCase(),
                style: const TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          )),
          // Expanded(child: Text(value2.toTitleCase(), style: const TextStyle(fontSize: 26.0))),
        ],
      ),
    );
    return text;
  }
}
