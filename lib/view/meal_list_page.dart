import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projek_tpm/helper/shared_preference.dart';
import 'package:projek_tpm/model/meal_list_model.dart';
import 'package:projek_tpm/source/meal_source.dart';
import 'package:projek_tpm/view/bottom_nav.dart';
import 'package:projek_tpm/view/meal_category.dart';
import 'detail_page.dart';

class MealListPage extends StatefulWidget {
  final String value;
  final int index;
  const MealListPage({Key? key, required this.value, required this.index})
      : super(key: key);

  @override
  State<MealListPage> createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  late int index = widget.index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List By  ${widget.value}"),
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
      body: _buildListMeal(),
    );
  }

  Widget _buildListMeal() {
    return FutureBuilder(
        future: index == 1
            ? MealSource.instance.loadByCategory(category: widget.value)
            : index == 2
                ? MealSource.instance
                    .loadByIngredient(ingredient: widget.value.toUnderScore())
                : index == 3
                    ? MealSource.instance
                        .loadByAlphabet(alphabet: widget.value.toLowerCase())
                    : index == 4
                        ? MealSource.instance.loadByArea(area: widget.value)
                        : MealSource.instance
                            .loadBySearch(search: widget.value.toLowerCase()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            MealList mealList = MealList.fromJson(snapshot.data);
            return _buildSuccessSection(mealList);
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
    return const Center(
        child: Text("No Internet Connection",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0)));
  }

  Widget _buildSuccessSection(MealList data) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: data.meals != null
                ? ListView.builder(
                    itemCount: data.meals?.length,
                    itemBuilder: (BuildContext context, int index) {
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
                                onTap: () async {
                                  String username =
                                      await SharedPreference.getUsername();
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return DetailPage(
                                        username: username,
                                        data: data,
                                        index: index);
                                  }));
                                },
                                child: _buildItemList(data, index))),
                      );
                    },
                  )
                : Center(
                    child: Center(
                        child: Text("Resep Tidak Ada",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30.0)))),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(MealList data, int index) {
    String imageUrl = "${data.meals![index].strMealThumb}";
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
                  child: Image.network(
                    imageUrl,
                    width: 120.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "${data.meals![index].strMeal}".toTitleCase(),
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          // Expanded(child: Text(value2.toTitleCase(), style: const TextStyle(fontSize: 26.0))),
        ],
      ),
    );
    return text;
  }
}
