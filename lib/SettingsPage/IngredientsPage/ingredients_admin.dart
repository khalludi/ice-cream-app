import 'package:flutter/material.dart';
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
  final List<Ingredient> passedIngredients;
  IngredientsAdmin({
    Key key,
    @required this.passedIngredients,
  });

  @override
  _IngredientsAdminState createState() => _IngredientsAdminState();
}

class _IngredientsAdminState extends State<IngredientsAdmin> {
  List<Ingredient> ingredients;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    ingredients = widget.passedIngredients;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _buildBar(context),
      body: Center(
        child: SearchIngredients(
          ingredients: widget.passedIngredients,
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
  }
}
