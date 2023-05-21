import 'package:flutter/material.dart';
import 'package:projek_tpm/view/meal_area.dart';
import 'package:projek_tpm/view/meal_category.dart';
import 'package:projek_tpm/view/meal_ingredient.dart';
import 'package:projek_tpm/view/meal_list_page.dart';
import 'package:projek_tpm/view/random_detail_page.dart';

import 'bottom_nav.dart';
import 'favorit_meal_list_page.dart';
import 'my_recipe_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var alphabet = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tasty Food",
          style: TextStyle(fontFamily: 'Koulen', fontSize: 24.0),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        color: Colors.green.shade50,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenu(),
              _buildItemFavorite(
                  "My Favorite", Colors.green, widget.username, 1),
              _buildItemFavorite(
                  "My Recipes", Colors.deepOrangeAccent, widget.username, 2),
              const Center(
                  child: Text(
                "\nBy Alphabet",
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Koulen',
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              )),
              _buildAlphabet(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 42, 28, 18),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 2,
        mainAxisSpacing: 15,
      ),
      children: [
        _buildItem("Category", "assets/images/1.png", 1),
        _buildItem("Ingredient", "assets/images/2.png", 2),
        _buildItem("Random", "assets/images/3.png", 3),
        _buildItem("Area", "assets/images/4.png", 4)
      ],
    );
  }

  Widget _buildCircleDecoration({required double height}) {
    return Positioned(
      top: -height * 0.616,
      left: -height * 0.53,
      child: CircleAvatar(
        radius: (height * 1.03) / 2,
        backgroundColor: Colors.white.withOpacity(0.14),
        child: Container(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildItem(String title, String imageDir, int route) {
    return LayoutBuilder(builder: (context, constrains) {
      return Stack(
        children: <Widget>[
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => route == 1
                            ? CategoryListPage()
                            : route == 2
                                ? IngredientsListPage()
                                : route == 3
                                    ? RandomDetailPage()
                                    : AreaListPage()),
                  );
                },
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        imageDir,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const CircularProgressIndicator(),
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Center(
                        child: Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16.0,
                              color: Colors.white,
                              fontFamily: 'Franklin Gothic Demi Cond'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildItemFavorite(String title, color, String name, int i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
        ),
        child: InkWell(
          splashColor: Colors.white10,
          highlightColor: Colors.white10,
          onTap: () {
            i == 1
                ? Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                    return MyFavoritPage(name: name);
                  }))
                : Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                    return MyRecipePage(name: name);
                  }));
          },
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24.0,
                  fontFamily: 'Koulen'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 22.0),
      child: Container(
        alignment: Alignment.center,
        // height: 200.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green.withOpacity(0.6), width: 4.0),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Wrap(
            runSpacing: 4,
            spacing: 4,
            alignment: WrapAlignment.center,
            children: List.generate(26, (index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MealListPage(value: alphabet[index], index: 3);
                      },
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepOrange.withOpacity(0.8),
                  ),
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Text(
                    alphabet[index],
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
