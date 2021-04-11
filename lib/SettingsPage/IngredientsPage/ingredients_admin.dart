import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'ingredient.dart';
import 'search_ingredients.dart';
import 'ingredient_dialog.dart';

/// The [IngredientsAdmin] widget is a page that allows admin users to create, read, update, and delete (CRUD) ingredients.
///
/// Create: use the floating action button in the bottom right corner.
///         Note that this widget does not check whether the ingredient already exists in the database.
/// Read:   use the search bar at the top to search for ingredients in the SQL database.
/// Update: tap on ingredients (represented as TextFields) and edit the ingredient name in the SQL database and the UI.
/// Delete: tap the delete icon to the right of the ingredient you want to delete in the SQL database and the UI.

typedef Callback = Function(int);

class IngredientsAdmin extends StatefulWidget {
  // final List<Ingredient> passedIngredients;
  IngredientsAdmin({
    Key key,
  });

  @override
  _IngredientsAdminState createState() => _IngredientsAdminState();
}

class _IngredientsAdminState extends State<IngredientsAdmin> {
  Future<List<Ingredient>> futureIngredients;
  List<Ingredient> ingredients;
  String url = '192.168.0.7:8080';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    futureIngredients = fetchIngredients();
    super.initState();
  }

  Future<List<Ingredient>> fetchIngredients() async {
    // final response =
    //     await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));
    final response = await http.get(Uri.http(url, "ingredients"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data['ingredients'] as List;
      List<Ingredient> ingredients =
          (rest).map((i) => Ingredient.fromJson(i)).toList();
      return ingredients;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("build run");
    return FutureBuilder<List<Ingredient>>(
      future: futureIngredients,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ingredients = snapshot.data;
          return buildScaffold(context);
        } else if (snapshot.hasError) {
          return Scaffold(
            key: scaffoldKey,
            appBar: _buildBar(context),
            body: Center(
              child: Text("Error getting ingredients data"),
            ),
          );
        }
        // By default, show a loading spinner.
        return Scaffold(
          key: scaffoldKey,
          appBar: _buildBar(context),
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _buildBar(context),
      body: Center(
        child: SearchIngredients(
          ingredients: ingredients,
          scaffoldKey: scaffoldKey,
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: launchAddDialog,
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text(
        'ADMIN: Ingredients',
        style: TextStyle(
          fontFamily: 'Nexa',
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Colors.purple, Colors.blue],
          ),
        ),
      ),
    );
  }

  void launchAddDialog() async {
    List<Object> result = await showDialog(
      context: context,
      builder: (_) => IngredientDialog(context: context),
    );
    Ingredient ingredient = result[0];
    if (ingredient != null) addIngredient(ingredient);
  }

  void addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
    setState(() {});
    addIngredientToDatabase(ingredient);
  }

  void addIngredientToDatabase(Ingredient ingredient) async {
    var data = {
      'ingredient_id': '100',
      'name': ingredient.name,
    };
    String body = json.encode(data);
    http.Response response = await http.post(
      Uri.http(
        url,
        "ingredients",
      ),
      headers: {"Accept": "application/json"},
      body: body,
    );
    log("addIngredient response body: " + response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
    } else {}
  }
}
