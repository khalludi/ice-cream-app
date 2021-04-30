import 'package:flutter/material.dart';
import '../backend_data.dart';
import 'Products.dart';
import 'ProductsDialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ice_cream_social/backend_data.dart';

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
  String url = 'my-gateway-1j4bd062.uc.gateway.dev';
  String username = 'root';
  String password = 'testtest';

  int product_id;
  String product_name;
  String brand_name;
  String subhead;
  String description;
  double avg_rating;
  int num_ratings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Product"),
      content: Form(
        key: _formKey,
        child: new Column(
          children: [
            Expanded(child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Product ID',
                labelText: 'Product ID *',
              ),
              onSaved: (String value){
                product_id = int.parse(value);
              },
            ),
            ),
            Expanded(child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Product Name',
                labelText: 'Product Name *',
              ),
              onSaved: (String value){
                product_name = value;
              },
            ),
            ),
            Expanded(child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Brand Name',
                labelText: 'Brand Name *',
              ),
              onSaved: (String value){
                brand_name = value;
              },
            ),
            ),
            Expanded(child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Subhead',
                labelText: 'Subhead *',
              ),
              onSaved: (String value){
                subhead = value;
              },
            ),
            ),
            Expanded(child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Description',
                labelText: 'Description *',
              ),
              onSaved: (String value){
                description = value;
              },
            ),
            ),
            Expanded(child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Average Rating',
                labelText: 'Average Rating *',
              ),
              onSaved: (String value){
                avg_rating = double.parse(value);
              },
            ),
            ),
            Expanded(child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Number of Ratings',
                labelText: 'Number of Ratings *',
              ),
              onSaved: (String value){
                num_ratings = int.parse(value);
              },
            ),)
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
              //Navigator.pop(context, [null, DialogAction.Cancel.index]),
          child: Text('CANCEL'),
        ),
        TextButton(
          child: Text('ADD'),
          onPressed: () {
            addToDB();
            setState(() {

            });
          },
        ),
      ],
    );
  }

  Future<void> addToDB() async {
    var data = {
      product_id: product_id,
      product_name: product_name,
      subhead: subhead,
      description: description,
      avg_rating: avg_rating,
      num_ratings: num_ratings
    };

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    String body = json.encode(data);
    http.Response response = await http.post(
      Uri.https(
        url,
        "add-product",
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
}
