import 'package:flutter/material.dart';
import 'Products.dart';
import 'dart:developer';

/// [IngredientTextField] is a custom TextField widget that represents the name of an ingredient.
/// Users can click to edit the name of an ingredient, and if their change is valid,
/// their change will be updated in the front-end and in the SQL database.
///
/// Written with help from Flutter Discord community.
class ProductsTextField extends StatefulWidget {
  final Products product;
  final int index;
  final Function(Products, int) updateProduct;
  final scaffoldKey;

  ProductsTextField({
    Key key,
    @required this.product,
    @required this.index,
    @required this.updateProduct,
    @required this.scaffoldKey,
  }) : super(key: key);
  @override
  _ProductsTextFieldState createState() => _ProductsTextFieldState();
}

class _ProductsTextFieldState extends State<ProductsTextField> {
  TextEditingController controller;
  String product_name;
  final focusNode = FocusNode();

  @override
  void initState() {
    product_name = widget.product.product_name;
    controller = TextEditingController(text: product_name);
    focusNode.addListener(onTextFieldChange);
    super.initState();
  }

  void onTextFieldChange() async {
    if (product_name == controller.text) return;
    if (controller.text.isEmpty) {
      SnackBar snackBar =
      SnackBar(content: Text('Invalid product! Old name restored.'));
      widget.scaffoldKey.currentState.showSnackBar(snackBar);
      Future.delayed(const Duration(milliseconds: 500), () {
        controller.text = product_name;
        setState(() {});
      });
    } else {
      SnackBar snackBar = SnackBar(content: Text('Updated product!'));
      widget.scaffoldKey.currentState.showSnackBar(snackBar);
      product_name = controller.text;
      widget.updateProduct(
          Products(
            product_name: controller.text,
            //ingredient_id: widget.ingredient.ingredient_id,
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
          hintText: controller.text == "" ? "add new product" : null),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}