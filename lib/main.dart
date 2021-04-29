import 'package:flutter/material.dart';
import 'package:ice_cream_social/HomePage/search.dart';
import 'package:ice_cream_social/login/login_screen.dart';
import 'package:ice_cream_social/login/profile.dart';
import 'HomePage/FilterProducts.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'HomePage/Products.dart';
import 'package:ice_cream_social/backend_data.dart';
import 'package:provider/provider.dart';

typedef Callback = Function(int);

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(home: new HomePage());
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url;
  String username;
  String password;
  Future<List<Products>> futureProducts;
  List<Products> productsList;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BackendData providerBackendData;

  int _selectedIndex = 0;
  int loginChanged = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Lato');

  @override
  void initState() {
    // TODO: implement initState
    providerBackendData = Provider.of<BackendData>(
      context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;
    futureProducts = fetchProducts();
    super.initState();
  }

  Future<List<Products>> fetchProducts() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(Uri.https(url, "get-product-all"), headers: {
      "Accept": "application/json",
      'authorization': basicAuth,
    });
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // var rest = data as List;
      List<Products> product =
      (data).map((i) => Products.fromJson(i)).toList();
      return product;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    return null;
  }

  /**Bottom navigation drawer.**/
  List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateLoginChanged(int newId) {
    setState(() {
      loginChanged = newId;
    });
  }

  Widget chooseWidget() {
    if (_selectedIndex == 0) {
      return _widgetOptions[_selectedIndex];
    } else if (_selectedIndex == 1 && loginChanged == 0) {
      return _widgetOptions[1];
    } else if (_selectedIndex == 1 && loginChanged == 1) {
      return _widgetOptions[2];
    } else {
      return _widgetOptions[_selectedIndex];
    }
  }

  Widget build(BuildContext context) {
    _widgetOptions = [];
    _widgetOptions.add(SearchWidget());
    _widgetOptions.add(LoginScreen(
      onLoginChanged: updateLoginChanged,
    ));
    _widgetOptions.add(Profile(
      onLoginChanged: updateLoginChanged,
    ));

    return FutureBuilder<List<Products>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            productsList = snapshot.data;
            return buildList(context);
          } else{
            return Scaffold(
              key: scaffoldKey,
              appBar: _buildBar(context),
              body: Center(
                child: Text("Error getting products data"),
              ),
            );
          }
        }
    );
  }
  @override
  Widget buildList(BuildContext context) {
    return ListView.builder(
      itemCount: productsList.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1 +
                      200.0,
                ),
                color: Colors.white10,
                alignment: Alignment.center,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(productsList[index].product_name),
                        subtitle: Text(productsList[index].brand_name),
                      ),
                      ButtonTheme(
// make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('See More'),
                              onPressed: () {/* ... */},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text('ICE CREAM SOCIAL',
          style: TextStyle(fontFamily: 'Nexa', fontSize: 30, fontWeight: FontWeight.w700)),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.purple, Colors.blue])),
      ),
      //backgroundColor: Color(0x9C4FF2),
    );
  }
}

// A function that will convert a response body into a List<Photo>
List<Products> parseProducts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Products>((json) => Products.fromJson(json)).toList();
}
