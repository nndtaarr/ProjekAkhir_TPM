import 'package:flutter/material.dart';
import 'package:projek_tpm/helper/hive_database_fav.dart';
import 'package:projek_tpm/helper/shared_preference.dart';
import 'package:projek_tpm/model/meal_detail_model.dart';
import 'package:projek_tpm/source/meal_source.dart';
import 'package:projek_tpm/view/bottom_nav.dart';
import 'package:projek_tpm/view/meal_category.dart';

import '../main.dart';
import 'home_page.dart';
import 'meal_list_page.dart';

class RandomDetailPage extends StatefulWidget {
  const RandomDetailPage({Key? key}) : super(key: key);

  @override
  State<RandomDetailPage> createState() => _RandomDetailPageState();
}

class _RandomDetailPageState extends State<RandomDetailPage> {
  bool isFavorite = false;
  final HiveDatabaseFav _hiveFav = HiveDatabaseFav();
  @override
  Widget build(BuildContext context) {
    _hiveFav.showAll();
    debugPrint("${_hiveFav.getLengthAll()}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Lucky Recipe!!!"),
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
    return FutureBuilder(
        future: MealSource.instance.loadRandomDetail(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            MealDetail mealdetail = MealDetail.fromJson(snapshot.data);
            return _buildSuccessSection(mealdetail);
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

  Widget _buildSuccessSection(MealDetail data) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildHeader(data),
            _buildDescription(data),
            _buildIngredient(data),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(MealDetail data) {
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
                child: Image.network(
                  "${data.meals![0].strMealThumb}",
                  fit: BoxFit.fill,
                  width: 140.0,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200.0,
              height: 120.0,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${data.meals![0].strMeal}".toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "Meal ID. ${data.meals![0].idMeal}",
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Koulen'),
                    ),
                    Text(
                      "Meal Category: ${data.meals![0].strCategory}",
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Koulen'),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }

  Widget _buildDescription(MealDetail data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 9),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red.withOpacity(0.6),
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
                "${data.meals![0].strInstructions}",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredient(MealDetail data) {
    List<String> value = [
      "${data.meals![0].strIngredient1}",
      "${data.meals![0].strIngredient2}",
      "${data.meals![0].strIngredient3}",
      "${data.meals![0].strIngredient4}",
      "${data.meals![0].strIngredient5}",
      "${data.meals![0].strIngredient6}",
      "${data.meals![0].strIngredient7}",
      "${data.meals![0].strIngredient8}",
      "${data.meals![0].strIngredient9}",
      "${data.meals![0].strIngredient10}",
      "${data.meals![0].strIngredient11}",
      "${data.meals![0].strIngredient12}",
      "${data.meals![0].strIngredient13}",
      "${data.meals![0].strIngredient14}",
      "${data.meals![0].strIngredient15}",
    ];
    List<String> valueMeasure = [
      "${data.meals![0].strMeasure1}",
      "${data.meals![0].strMeasure2}",
      "${data.meals![0].strMeasure3}",
      "${data.meals![0].strMeasure4}",
      "${data.meals![0].strMeasure5}",
      "${data.meals![0].strMeasure6}",
      "${data.meals![0].strMeasure7}",
      "${data.meals![0].strMeasure8}",
      "${data.meals![0].strMeasure9}",
      "${data.meals![0].strMeasure10}",
      "${data.meals![0].strMeasure11}",
      "${data.meals![0].strMeasure12}",
      "${data.meals![0].strMeasure13}",
      "${data.meals![0].strMeasure14}",
      "${data.meals![0].strMeasure15}",
    ];
    value.removeWhere((value) => value == "");
    valueMeasure.removeWhere((value) => value == "");

    int i = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.teal.withOpacity(0.6),
            width: 5,
          ),
          borderRadius: BorderRadius.circular(15),
          color: Colors.teal.withOpacity(0.6),
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
                  color: Colors.white,
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
                      color: Colors.red.withOpacity(0.7),
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
                                width: 100.0,
                              ),
                              Text(
                                value[i].toTitleCase(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                valueMeasure[i].toTitleCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
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
