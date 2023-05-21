import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:projek_tpm/helper/hive_database_recipe.dart';
import 'package:projek_tpm/helper/shared_preference.dart';
import 'package:projek_tpm/hive_model/data_model.dart';
import 'package:projek_tpm/image_picker/image_picker_section.dart';
import 'package:projek_tpm/model/ingredient_list_model.dart';
import 'package:projek_tpm/source/meal_source.dart';

class CreateRecipe extends StatefulWidget {
  final String username;

  const CreateRecipe({Key? key, required this.username}) : super(key: key);

  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final HiveDatabaseRecipe _hiveRec = HiveDatabaseRecipe();
  final TextEditingController _searchController1 = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  final TextEditingController _searchController3 = TextEditingController();
  List<String> ingredients = [];
  String _recipename = "";
  String _insMeal = "";
  String _ingMeal1 = "";
  String _ingMeal2 = "";
  String _ingMeal3 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ur Recipes"),
      ),
      body: _buildFormRecipe(),
    );
  }

  Widget _buildFormRecipe() {
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
    ingredients = [];
    for (int i = 0; i < data.meals!.length; i++) {
      ingredients.add("${data.meals?[i].strIngredient}");
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Text(
              "\nGood to see you, ${widget.username}:)\n\nCreate your own recipe!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 3, color: Colors.red.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.red.withOpacity(0.6)),
              height: MediaQuery.of(context).size.height - 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImagePickerSection(),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildForm(),
            ),
            SizedBox(
              height: 24,
            ),
            _buildButtonSubmit()
          ],
        ),
      ),
    );
  }

  Widget _formInput(
      {required String hint,
      required String label,
      required Function(String value) setStateInput,
      int maxLines = 1}) {
    return TextFormField(
      enabled: true,
      maxLines: maxLines,
      decoration: InputDecoration(
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.red),
          hintText: hint,
          label: Text(label),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.teal),
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.teal),
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      onChanged: setStateInput,
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        _formInput(
            hint: "Enter Recipe Name",
            label: "Recipe Name",
            setStateInput: (value) {
              setState(() {
                _recipename = value;
              });
            }),
        const SizedBox(
          height: 12,
        ),
        _formSuggest(1),
        const SizedBox(
          height: 12,
        ),
        _formSuggest(2),
        const SizedBox(
          height: 12,
        ),
        _formSuggest(3),
        const SizedBox(
          height: 12,
        ),
        _formInput(
            hint: "Instruction",
            label: "Type Instruction... ",
            setStateInput: (value) {
              setState(() {
                _insMeal = value;
              });
            },
            maxLines: 10),
      ],
    );
  }

  Widget _formSuggest(int ing) {
    List<String> getSuggestions(String query) {
      List<String> matches = <String>[];
      matches.addAll(ingredients);

      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
    }

    return TypeAheadField(
      hideOnEmpty: true,
      suggestionsCallback: (pattern) {
        return getSuggestions(pattern);
      },
      textFieldConfiguration: TextFieldConfiguration(
          controller: ing == 1
              ? _searchController1
              : ing == 2
                  ? _searchController2
                  : _searchController3,
          decoration: const InputDecoration(
              fillColor: Colors.white,
              labelStyle: TextStyle(color: Colors.redAccent),
              labelText: "Ingredient",
              hintText: "Ingredient",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.teal),
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.teal),
                  borderRadius: BorderRadius.all(Radius.circular(25.0))))),
      onSuggestionSelected: (String suggestion) {
        ing == 1
            ? _searchController1.text = suggestion
            : ing == 2
                ? _searchController2.text = suggestion
                : _searchController3.text = suggestion;
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
    );
  }

  Widget _buildButtonSubmit() {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          String img = await SharedPreference.getImage();
          _hiveRec.addData(MyRecipeModel(
              name: widget.username,
              nameMeal: _recipename,
              imageMeal: img,
              ingMeal1: _searchController1.text,
              ingMeal2: _searchController2.text,
              ingMeal3: _searchController3.text,
              insMeal: _insMeal));
          Navigator.pop(context);
        },
        child: Text("Add"),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: TextStyle(fontSize: 16)),
      ),
    );
  }
}
