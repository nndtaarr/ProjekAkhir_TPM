// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:projek_tpm/source/meal_source.dart';

import 'package:projek_tpm/view/home_page.dart';
import 'package:projek_tpm/view/kesan_dan_pesan.dart';
import 'package:projek_tpm/view/meal_category.dart';
import 'package:projek_tpm/view/money_converter_page.dart';
import 'package:projek_tpm/view/profile_page.dart';

import '../helper/shared_preference.dart';
import '../model/meal_list_model.dart';
import 'detail_page.dart';

// ignore: must_be_immutable
class BottomNav extends StatefulWidget {
  String? username;
  BottomNav({
    Key? key,
    this.username,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late String name;

  @override
  void initState() {
    super.initState();
    name = widget.username!;
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetoptions = [
      HomePage(username: name),
      const MoneyConverterPage(),
      const KesanPesanPage(),
      const ProfilePage()
    ];
    return Scaffold(
      body: widgetoptions.elementAt(selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.green,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        height: 50,
        index: selectedIndex,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.calculate_rounded, size: 30, color: Colors.white),
          Icon(Icons.note_alt, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}

class SearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: MealSource.instance.loadBySearch(search: query),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        } else {
          MealList mealList = MealList.fromJson(snapshot.data);
          return ListView.builder(
            itemCount: mealList.meals?.length,
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
                      String username = await SharedPreference.getUsername();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DetailPage(
                                username: username,
                                data: mealList,
                                index: index);
                          },
                        ),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color:
                                    Colors.deepOrange.shade600.withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    "${mealList.meals![index].strMealThumb}",
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
                                "${mealList.meals![index].strMeal}"
                                    .toTitleCase(),
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
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Empty'),
    );
  }
}
