import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:developer';
import 'ingredient.dart';
import 'ingredient_dialog.dart';
import 'ingredient_textfield.dart';

class SearchIngredients extends StatefulWidget {
  final List<Ingredient> ingredients;

  const SearchIngredients({
    Key key,
    @required this.ingredients,
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

    // ingredients.insert(
    //     0,
    //     Ingredient(
    //       id: -1,
    //       name: "",
    //     ));
    super.initState();
  }

  @override
  didUpdateWidget(covariant SearchIngredients oldWidget) {
    super.didUpdateWidget(oldWidget);
    log("old key: " +
        oldWidget.key.toString() +
        ", new key: " +
        widget.key.toString());
    if (oldWidget != widget) {
      log("DIFFERENT WIDGET");
      setState(() {});
    }
  }

  Widget getIngredientWidget(Ingredient ingredient, int index) {
    return Card(
      child: ListTile(
        title: IngredientTextField(item: ingredient.name),
        trailing: Visibility(
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
    );
  }

  Widget getAddIngredientWidget(index) {
    return new Card(
      child: ListTile(
        title: textFields[index],
        trailing: IconButton(
          icon: new Icon(Icons.add_circle, color: Colors.green),
          onPressed: () {
            addIngredient(Ingredient(id: -1, name: controllers[index].text));
          },
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
    // log("searching!");
    // List<Ingredient> sublist = ingredients
    //     .where((ingredient) =>
    //         ingredient.name.toLowerCase().startsWith(search.toLowerCase()))
    //     .toList();
    // sublist.forEach((elem) => log(elem.name));
    // return sublist;
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
        // if (index == 0) {
        //   return getAddIngredientWidget(index);
        // } else {
        //   return getIngredientWidget(ingredient, index);
        // }
        return getIngredientWidget(ingredient, index);
      },
    );
  }
}
