import 'package:flutter/material.dart';
import 'ingredient.dart';

/// The [IngredientDialog] widget displays a dialog relating to ingredients.
/// Currently there are 2 possible dialogs
///     1. confirm the user wants to  delete an ingredient, or
///     2. add an ingredient using user input.

enum DialogAction { Add, Edit, Delete, Cancel }

class IngredientDialog extends StatefulWidget {
  final BuildContext context;
  final Ingredient ingredient;

  IngredientDialog({
    @required this.context,
    this.ingredient,
  });

  @override
  State<StatefulWidget> createState() => IngredientDialogState();
}

class IngredientDialogState extends State<IngredientDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ingredient != null)
      return DeleteIngredientDialog(ingredient: widget.ingredient);
    else
      return AddIngredientDialog();
  }
}

class DeleteIngredientDialog extends StatelessWidget {
  const DeleteIngredientDialog({Key key, @required this.ingredient})
      : super(key: key);

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    String ingredientName = ingredient.name;
    return AlertDialog(
      title: Text('Delete Ingredient?'),
      content: Text(
          'Are you sure you want to delete the $ingredientName ingredient?'),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, [null, DialogAction.Cancel.index]),
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(context, [null, DialogAction.Delete.index]),
          child: Text('DELETE'),
        ),
      ],
    );
  }
}

class AddIngredientDialog extends StatefulWidget {
  const AddIngredientDialog({
    Key key,
  }) : super(key: key);

  @override
  _AddIngredientDialogState createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<AddIngredientDialog> {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Ingredient"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: nameController,
          validator: (value) {
            return value.isNotEmpty ? null : 'Invalid field';
          },
          decoration: InputDecoration(hintText: 'name'),
          maxLines: null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, [null, DialogAction.Cancel.index]),
          child: Text('CANCEL'),
        ),
        TextButton(
          child: Text('ADD'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Ingredient newIngredient = Ingredient(
                name: nameController.text,
              );
              Navigator.pop(context, [newIngredient, DialogAction.Add]);
            }
          },
        ),
      ],
    );
  }
}
