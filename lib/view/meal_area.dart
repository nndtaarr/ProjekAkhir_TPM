import 'package:flutter/material.dart';

import 'package:projek_tpm/helper/shared_preference.dart';
import 'package:projek_tpm/model/area_list_model.dart';
import 'package:projek_tpm/source/meal_source.dart';
import 'package:projek_tpm/view/bottom_nav.dart';

import 'meal_list_page.dart';

class AreaListPage extends StatefulWidget {
  const AreaListPage({Key? key}) : super(key: key);

  @override
  State<AreaListPage> createState() => _AreaListPageState();
}

class _AreaListPageState extends State<AreaListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes Area"),
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
      body: _buildListArea(),
    );
  }

  Widget _buildListArea() {
    return FutureBuilder(
        future: MealSource.instance.loadArea(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            AreaList areaList = AreaList.fromJson(snapshot.data);
            return _buildSuccessSection(areaList);
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

  Widget _buildSuccessSection(AreaList data) {
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
                borderRadius: BorderRadius.circular(15),
                color: Colors.redAccent.withOpacity(0.7),
              ),
              child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MealListPage(
                          value: "${data.meals?[index].strArea}", index: 4);
                    }));
                  },
                  child: _buildMealCategory(data, index)),
            ));
      },
    );
  }

  Widget _buildMealCategory(AreaList data, int index) {
    var text = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text("${data.meals?[index].strArea}",
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center),
        ),
      ),
    );
    return text;
  }
}
