import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'ingredient.dart';
import 'ingredient_dialog.dart';
import 'ingredient_textfield.dart';

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
  List<TextEditingController> controllers;
  List<TextFormField> textFields;
  SearchBar<Ingredient> searchBar;
  bool isUsingSearchBar;
  String url = '192.168.0.7:8080';

  @override
  initState() {
    controllers = [];
    textFields = [];
    ingredients = widget.ingredients;
    isUsingSearchBar = false;

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
    final response = await http.get(
        Uri.http(
          url,
          "ingredients/hazelnuts",
        ),
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
      log("Error!!");
    }
    return null;
  }

  void addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
    setState(() {});
  }

  void deleteIngredient(int index) async {
    await deleteIngredientFromDatabase(ingredients[index]);
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
    log("delete ingredient response body: " + response.body);
    if (response.statusCode == 200) {
    } else {}
  }

  void updateIngredient(Ingredient editedIngredient, int index) {
    ingredients[index] = editedIngredient;
    setState(() {});
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
