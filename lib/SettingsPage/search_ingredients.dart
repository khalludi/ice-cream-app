import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:developer';
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
        ingredient: widget.ingredients[index],
      ),
    );
    if (result[1] == DialogAction.Delete.index) deleteIngredient(index);
  }

  Future<List<Ingredient>> search(String search) async {
    isUsingSearchBar = true;
    log("isUsingSearchBar: " + isUsingSearchBar.toString());
    await Future.delayed(Duration(seconds: 2));
    return ingredients.sublist(1, 3);
  }

  void addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
    setState(() {});
  }

  void deleteIngredient(int index) {
    log("delete ingredient w name:" + ingredients[index].name);
    // ingredients = List.from(ingredients)..removeAt(index);
    ingredients.removeAt(index);
    log("new ingredient length: " + ingredients.length.toString());
    setState(() {});
    ingredients.forEach((element) {
      log(element.name);
    });
  }

  void updateIngredient(Ingredient editedIngredient, int index) {
    ingredients[index] = editedIngredient;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("build run");
    // make dynamic list of TextEditingControllers
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
