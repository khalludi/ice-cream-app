import 'package:flutter/material.dart';
import 'Products.dart';
import 'AddProduct.dart';
import 'DeleteProduct.dart';

enum DialogAction { Add, Edit, Delete, Cancel }

class ProductsDialog extends StatefulWidget {
  final BuildContext context;
  final Products product;

  ProductsDialog({
    @required this.context,
    this.product,
  });

  @override
  State<StatefulWidget> createState() => ProductsDialogState();
}

class ProductsDialogState extends State<ProductsDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product != null)
      return DeleteProduct(product: widget.product);
    else
      return AddProduct();
  }
}

