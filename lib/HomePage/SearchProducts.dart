import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'Products.dart';
import 'ProductsDialog.dart';
import 'package:ice_cream_social/backend_data.dart';
import 'ProductsTextField.dart';

class SearchProducts extends StatefulWidget {
  final List<Products> productsList;
  final scaffoldKey;

  const SearchProducts({
    Key key,
    @required this.productsList,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  List<Products> productsList;
  SearchBar<Products> searchBar;
  bool isUsingSearchBar;
  BackendData providerBackendData;
  String url;
  String username;
  String password;

  @override
  initState() {
    productsList = widget.productsList;
    isUsingSearchBar = false;
    providerBackendData = Provider.of<BackendData>(
      context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;

    super.initState();
  }

  Widget getProductsWidget(Products product, int index) {
    return Card(
      child: ListTile(
        title: ProductsTextField(
          product: product,
          index: index,
          updateProduct: updateProduct,
          scaffoldKey: widget.scaffoldKey,
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Visibility(
            visible: !isUsingSearchBar,
            child: IconButton(
              onPressed: () => launchProductsDialog(index),
              icon: Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void launchProductsDialog(int index) async {
    List<Object> result = await showDialog(
      context: context,
      builder: (_) => ProductsDialog(
        context: context,
        product: productsList[index],
      ),
    );
    if (result[1] == DialogAction.Delete.index) deleteProduct(index);
  }

  Future<List<Products>> search(String query) async {
    isUsingSearchBar = true;
    await Future.delayed(Duration(seconds: 2));

    var data = {'search_term': query};
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
      Uri.https(
        url,
        //CHANGE get-ingredient
        "get-ingredient",
        data,
      ),
      headers: {
        "Accept": "application/json",
        'authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Products> products =
      (data).map((i) => Products.fromJson(i)).toList();
      return products;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    return null;
  }

  void addProduct(Products product) {
    productsList.add(product);
    setState(() {});
  }

  void deleteProduct(int index) async {
    productsList.removeAt(index);
    setState(() {});
  }

  void deleteProductFromDatabase(Products products) async {
    var queryParameters = {
      'product_id': '100',
    };
    String product_id = products.product_id.toString();
    http.Response response = await http.delete(
      Uri.https(
        url,
        "products/$product_id",
        queryParameters,
      ),
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
    } else {}
  }

  void updateProduct(Products editedProduct, int index) {
    productsList[index] = editedProduct;
    setState(() {});
  }

  void updateProductInDatabase(Products product) async {
    var data = {
      'product_id': (productsList.length + 1),
      'product_name': product.product_name,
      'brand_name': product.brand_name,
      'subhead': product.subhead,
      'description': product.description,
      'avg_rating': product.avg_rating,
      'num_ratings': product.num_ratings
    };
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    String body = json.encode(data);
    http.Response response = await http.post(
      Uri.https(
        url,
        "products",
      ),
      headers: {
        // "Accept": "application/json",
        'authorization': basicAuth,
      },
      body: body,
    );
    if (response.statusCode == 200) {
      print("Success");
      var data = json.decode(response.body);
    } else {
      print("Fail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar<Products>(
      key: Key(productsList.length.toString()),
      searchBarPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      listPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      suggestions: productsList,
      onCancelled: () => isUsingSearchBar = false,
      hintText: "search products",
      shrinkWrap: true,
      onSearch: search,
      onItemFound: (Products product, int index) {
        return getProductsWidget(product, index);
      },
    );
  }
}