import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'ingredient.dart';

/// The [IngredientsAdmin] widget is a page that allows admin users to create, read, update, and delete (CRUD) ingredients.
///
/// Create: use the text field at the bottom and click "add" to create a new ingredient in the SQL database and the UI.
///         Note that this widget does not check whether the ingredient already exists in the database.
/// Read:   use the search bar at the top to search for ingredients in the SQL database.
/// Update: tap on ingredients (represented as TextFields) and edit the ingredient name in the SQL database and the UI.
/// Delete: tap the delete icon to the right of the ingredient you want to delete in the SQL database and the UI.

typedef Callback = Function(int);

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class IngredientsAdmin extends StatefulWidget {
  List<Ingredient> ingredients;
  IngredientsAdmin({
    @required this.ingredients,
  });

  @override
  _IngredientsAdminState createState() => _IngredientsAdminState();

  Future<List<Ingredient>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(search.length, (int index) {
      return ingredients[index];
    });
  }
}

class _IngredientsAdminState extends State<IngredientsAdmin> {
  List<Object> listItems;
  List<TextEditingController> controllers;
  List<TextFormField> textFields;

  @override
  initState() {
    controllers = [];
    textFields = [];
    widget.ingredients.insert(
        0,
        Ingredient(
          id: -1,
          name: "",
        ));
    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // make dynamic list of TextEditingControllers
    widget.ingredients.forEach(
      (ingredient) {
        var textEditingController =
            new TextEditingController(text: ingredient.name);
        controllers.add(textEditingController);
        return textFields.add(
          new TextFormField(
            controller: textEditingController,
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              return value.isNotEmpty ? null : 'Invalid field';
            },
            // remove underlines
            decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: ingredient.name == "" ? "add new ingredient" : null),
          ),
        );
      },
    );
    return Scaffold(
      appBar: _buildBar(context),
      body: Center(
        child: SearchBar<Ingredient>(
          searchBarPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          listPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          suggestions: widget.ingredients,
          hintText: "search for ingredients",
          shrinkWrap: true,
          onSearch: search,
          onItemFound: (Ingredient ingredient, int index) {
            if (index == 0) {
              return getAddIngredientWidget(index);
            } else {
              return getIngredientWidget(ingredient, index);
            }
          },
        ),
      ),
    );
  }

  Future<List<Ingredient>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return widget.ingredients.sublist(1, 3);
  }

  void addIngredient(Ingredient ingredient) {
    widget.ingredients.add(ingredient);
    setState(() {});
  }

  void deleteIngredient(int index) {
    widget.ingredients.removeAt(index);
    setState(() {});
  }

  void updateIngredient(Ingredient editedIngredient, int index) {
    widget.ingredients[index] = editedIngredient;
    setState(() {});
  }

  Widget getIngredientWidget(Ingredient ingredient, int index) {
    return Card(
      child: ListTile(
        title: textFields[index],
        trailing: Icon(
          Icons.remove_circle,
          color: Colors.red,
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
}
