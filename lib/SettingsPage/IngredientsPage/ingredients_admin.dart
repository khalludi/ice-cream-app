import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'ingredient.dart';
import 'search_ingredients.dart';
import 'ingredient_dialog.dart';
import 'package:provider/provider.dart';
import 'package:ice_cream_social/backend_data.dart';

/// The [IngredientsAdmin] widget is a page that allows admin users to create, read, update, and delete (CRUD) ingredients.
///
/// Create: use the floating action button in the bottom right corner.
///         Note that this widget does not check whether the ingredient already exists in the database.
/// Read:   use the search bar at the top to search for ingredients in the SQL database.
/// Update: tap on ingredients (represented as TextFields) and edit the ingredient name in the SQL database and the UI.
/// Delete: tap the delete icon to the right of the ingredient you want to delete in the SQL database and the UI.

typedef Callback = Function(int);

class IngredientsAdmin extends StatefulWidget {
  IngredientsAdmin({
    Key key,
  });

  @override
  _IngredientsAdminState createState() => _IngredientsAdminState();
}

class _IngredientsAdminState extends State<IngredientsAdmin> {
  Future<List<Ingredient>> futureIngredients;
  List<Ingredient> ingredients;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BackendData providerBackendData;
  String url;
  String username;
  String password;

  @override
  void initState() {
    providerBackendData = Provider.of<BackendData>(
      context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;
    futureIngredients = fetchIngredients();
    super.initState();
  }

  Future<List<Ingredient>> fetchIngredients() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(Uri.http(url, "ingredients"), headers: {
      "Accept": "application/json",
      'authorization': basicAuth,
    });
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // var rest = data as List;
      List<Ingredient> ingredients =
          (data).map((i) => Ingredient.fromJson(i)).toList();
      return ingredients;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
    ingredients.insert(0, ingredient);
    setState(() {});
    // addIngredientToDatabase(ingredient);
  }

  void addIngredientToDatabase(Ingredient ingredient) async {
    var data = {
      'ingredient_id': (ingredients.length + 1).toString(),
      'name': ingredient.name,
    };
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    String body = json.encode(data);
    http.Response response = await http.post(
      Uri.http(
        url,
        "ingredients",
      ),
      headers: {
        // "Accept": "application/json",
        'authorization': basicAuth,
      },
      body: body,
    );
    if (response.statusCode == 200) {
      print("ingredientAdmin success");
      var data = json.decode(response.body);
    } else {
      print("ingredientAdmin fail");
    }
  }
}
