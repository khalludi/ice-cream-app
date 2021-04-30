import 'package:flutter/material.dart';
import 'Products.dart';
import 'ProductsDialog.dart';

class DeleteProduct extends StatelessWidget {
  const DeleteProduct({Key key, @required this.product})
      : super(key: key);

  final Products product;

  @override
  Widget build(BuildContext context) {
    String product_name = product.product_name;
    return AlertDialog(
      title: Text('Delete Product?'),
      content: Text(
          'Are you sure you want to delete $product_name?'),
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