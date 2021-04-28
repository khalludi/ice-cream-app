import 'package:flutter/material.dart';
import 'Products.dart';
import 'ProductsDialog.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key key,
  }) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Product"),
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
              Products newProduct = Products(
                product_name: nameController.text,
              );
              Navigator.pop(context, [newProduct, DialogAction.Add]);
            }
          },
        ),
      ],
    );
  }
}