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
    String url = '10.0.2.2:3000';
    await Future.delayed(Duration(seconds: 2));

    var data = {'search_term': query};
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
      Uri.http(
        url,
        "ingredients/nameParam",
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
    // await deleteIngredientFromDatabase(ingredients[index]);
    ingredients.removeAt(index);
    setState(() {});
  }

  void deleteIngredientFromDatabase(Ingredient ingredient) async {
    String url = '192.168.0.7:8080';
    var queryParameters = {
      'ingredient_id': '100',
    };
    String ingredient_id = ingredient.ingredient_id.toString();
    http.Response response = await http.delete(
      Uri.http(
        url,
        "ingredients/$ingredient_id",
        queryParameters,
      ),
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
    } else {}
  }

  void updateIngredient(Ingredient editedIngredient, int index) {
    ingredients[index] = editedIngredient;
    // updateIngredientInDatabase(editedIngredient)
    setState(() {});
  }

  void updateIngredientInDatabase(Ingredient ingredient) async {
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
