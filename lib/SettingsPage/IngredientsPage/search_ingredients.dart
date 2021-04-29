import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'ingredient.dart';
import 'ingredient_dialog.dart';
import 'ingredient_textfield.dart';
import 'package:ice_cream_social/backend_data.dart';

/// The [SearchIngredients] widget uses the FlappySearchBar so that the user can search, edit, and
/// delete ingredients.

class SearchIngredients extends StatefulWidget {
  final List<Ingredient> ingredients;
  final scaffoldKey;

  const SearchIngredients({
    Key key,
    @required this.ingredients,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _SearchIngredientsState createState() => _SearchIngredientsState();
}

class _SearchIngredientsState extends State<SearchIngredients> {
  List<Ingredient> ingredients;
  SearchBar<Ingredient> searchBar;
  bool isUsingSearchBar;
  BackendData providerBackendData;
  String url;
  String username;
  String password;

  @override
  initState() {
    ingredients = widget.ingredients;
    isUsingSearchBar = false;
    providerBackendData = Provider.of<BackendData>(
      context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;

    super.initState();
  }

  Widget getIngredientWidget(Ingredient ingredient, int index) {
    return Card(
      child: ListTile(
        title: IngredientTextField(
          ingredient: ingredient,
          index: index,
          updateIngredient: updateIngredient,
          scaffoldKey: widget.scaffoldKey,
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Visibility(
            visible: !isUsingSearchBar,
            child: IconButton(
              onPressed: () => launchIngredientDialog(index),
              icon: Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void launchIngredientDialog(int index) async {
    List<Object> result = await showDialog(
      context: context,
      builder: (_) => IngredientDialog(
        context: context,
        ingredient: ingredients[index],
      ),
    );
    if (result[1] == DialogAction.Delete.index) deleteIngredient(index);
  }

  Future<List<Ingredient>> search(String query) async {
    isUsingSearchBar = true;
    await Future.delayed(Duration(seconds: 2));

    var data = {'search_term': query};
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
      Uri.https(
        url,
        "get-ingredient",
        data,
      ),
      headers: {
        "Accept": "application/json",
        'authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Ingredient> ingredients =
          (data).map((i) => Ingredient.fromJson(i)).toList();
      return ingredients;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    return null;
  }

  void addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
    setState(() {});
  }

  void deleteIngredient(int index) async {
    await deleteIngredientFromDatabase(ingredients[index], index);
  }

  Future<bool> deleteIngredientFromDatabase(
      Ingredient ingredient, int index) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.delete(
<<<<<<< HEAD
=======

>>>>>>> 66979de5ca7fd9e8e7dc32ed983197984747c340
      Uri.https(
        url,
        "ingredients",
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
      body: jsonEncode(<String, String>{
        'ingredient_id': ingredient.ingredient_id,
      }),
    );

    log("statuscode=" + response.statusCode.toString());
    if (response.statusCode == 200) {
      log("delete ingredient response: " + response.body);
      ingredients.removeAt(index);
      setState(() {});
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return false;
    }
  }

  void updateIngredient(Ingredient editedIngredient, int index) {
    ingredients[index] = editedIngredient;
    updateIngredientInDatabase(editedIngredient);
    setState(() {});
  }

  void updateIngredientInDatabase(Ingredient ingredient) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response = await http.post(
      Uri.https(
        url,
        "ingredients/edit",
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'old_ingredient_id': ingredient.ingredient_id.toString(),
          'name': ingredient.name,
        },
      ),
    );
    if (response.statusCode == 200) {
      print("ingredientAdmin success");
      var data = json.decode(response.body);
    } else {
      print("updateIngredient fail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar<Ingredient>(
      key: Key(ingredients.length.toString()),
      searchBarPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      listPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      suggestions: ingredients,
      onCancelled: () => isUsingSearchBar = false,
      hintText: "search ingredients",
      shrinkWrap: true,
      onSearch: search,
      onItemFound: (Ingredient ingredient, int index) {
        return getIngredientWidget(ingredient, index);
      },
    );
  }
}
