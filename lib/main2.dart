import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_cream_social/HomePage/search.dart';
import 'package:ice_cream_social/login/login_screen.dart';
import 'package:ice_cream_social/login/profile.dart';
import 'package:ice_cream_social/backend_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomePage/Products.dart';
import 'HomePage/Services.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(home: new HomePage());
  }
}

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  List<Products> _products;
  GlobalKey<ScaffoldState> _scaffoldKey;

  void initState(){
    super.initState();
    _products = [];
    _scaffoldKey = GlobalKey();
    _getProducts();
  }

  _getProducts(){
    Services.getProducts().then((products){
      setState((){
        _products = products;
      });
      print("Length ${_products.length}");
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              _getProducts();
            },
          )
        ],
      ),
    );
  }
}