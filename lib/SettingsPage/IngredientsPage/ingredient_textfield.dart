import 'package:flutter/material.dart';
import 'ingredient.dart';
import 'dart:developer';

/// [IngredientTextField] is a custom TextField widget that represents the name of an ingredient.
/// Users can click to edit the name of an ingredient, and if their change is valid,
/// their change will be updated in the front-end and in the SQL database.
///
/// Written with help from Flutter Discord community.

class IngredientTextField extends StatefulWidget {
  final Ingredient ingredient;
  final int index;
  final Function(Ingredient, int) updateIngredient;
  final scaffoldKey;

  IngredientTextField({
    Key key,
    @required this.ingredient,
    @required this.index,
    @required this.updateIngredient,
    @required this.scaffoldKey,
  }) : super(key: key);
  @override
  _IngredientTextFieldState createState() => _IngredientTextFieldState();
}

class _IngredientTextFieldState extends State<IngredientTextField> {
  TextEditingController controller;
  String ingredientName;
  final focusNode = FocusNode();

  @override
  void initState() {
    ingredientName = widget.ingredient.name;
    controller = TextEditingController(text: ingredientName);
    focusNode.addListener(onTextFieldChange);
    super.initState();
  }

  void onTextFieldChange() async {
    if (ingredientName == controller.text) return;
    if (controller.text.isEmpty) {
      SnackBar snackBar =
          SnackBar(content: Text('Invalid ingredient! Old name restored.'));
      widget.scaffoldKey.currentState.showSnackBar(snackBar);
      Future.delayed(const Duration(milliseconds: 500), () {
        controller.text = ingredientName;
        setState(() {});
      });
    } else {
      SnackBar snackBar = SnackBar(content: Text('Updated ingredient!'));
      widget.scaffoldKey.currentState.showSnackBar(snackBar);
      ingredientName = controller.text;
      widget.updateIngredient(
          Ingredient(
            name: controller.text,
            ingredient_id: widget.ingredient.ingredient_id,
          ),
          widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        return value.isNotEmpty ? null : 'Invalid field';
      },
      // remove underlines
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          hintText: controller.text == "" ? "add new ingredient" : null),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
