import 'package:flutter/material.dart';

class IngredientTextField extends StatefulWidget {
  IngredientTextField({
    Key key,
    this.item,
  }) : super(key: key);
  final String item;
  @override
  _IngredientTextFieldState createState() => _IngredientTextFieldState();
}

class _IngredientTextFieldState extends State<IngredientTextField> {
  TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.item);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
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
          hintText: widget.item == "" ? "add new ingredient" : null),
    );
  }
}
