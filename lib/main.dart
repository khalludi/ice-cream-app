import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_cream_social/HomePage/search.dart';
import 'package:ice_cream_social/login/login_screen.dart';
import 'package:ice_cream_social/login/profile.dart';
import 'package:ice_cream_social/login/authentication.dart';
import 'HomePage/filter.dart';
import 'package:ice_cream_social/backend_data.dart';
import 'HomePage/Products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BackendData()),
          ],
          child: new HomePage(),
        )
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Products>> futureProducts;
  List<Products> products;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BackendData providerBackendData;
  String url;
  String username;
  String password;

  @override
  void initState() {
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
  int _selectedIndex = 0;
  int loginChanged = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Lato');

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

  Widget chooseWidget(BuildContext context) {
    if (_selectedIndex == 0) {
      return _widgetOptions[_selectedIndex];
    } else if (_selectedIndex == 1 && loginChanged == 0) {
      return _widgetOptions[1];
    } else if (_selectedIndex == 1 && loginChanged == 1) {
      // LoginScreen wid = _widgetOptions[2] as LoginScreen;
      // wid.context = context;
      return _widgetOptions[2];
    } else {
      return _widgetOptions[_selectedIndex];
    }
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
      print(data);
      // var rest = data as List;
      List<Products> products =
      (data).map((i) => Products.fromJson(i)).toList();
      //print(product);
      return products;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Fail");
    }
    return null;
  }

  Widget build(BuildContext context) {
    Authentication auth = new Authentication();
    _widgetOptions = [];
    _widgetOptions.add(SearchWidget());
    _widgetOptions.add(LoginScreen(
      onLoginChanged: updateLoginChanged,
      auth: auth,
      context: context,
    ));

    return MaterialApp(
        home: Scaffold(
          // appBar: _buildBar(context),
          body: Builder(
            //builder: (context) => chooseWidget(context),
            builder: (context) => buildFuture(context)
          ),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
              //onPressed: launchAddDialog,
              child: Icon(Icons.add),
              backgroundColor: Colors.purple,
            ),
          ),
          /**Bottom navigation drawer.**/
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          ),
        ),
      );
  }

  Widget buildFuture(BuildContext context) {
    return FutureBuilder<List<Products>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          products = snapshot.data;
          print(products);
          return buildList(context);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Scaffold(
            key: scaffoldKey,
            appBar: _buildBar(context),
            body: Center(
              child: Text("Error getting products data"),
            ),
          );
        }
        // By default, show a loading spinner.
        return Scaffold(
          key: scaffoldKey,
          appBar: _buildBar(context),
          //body: buildSearch(context),
        );
      },
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text('ICE CREAM SOCIAL',
          style: TextStyle(
              fontFamily: 'Nexa', fontSize: 30, fontWeight: FontWeight.w700)),
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

  Widget buildList(BuildContext context) {
    return ListView.builder(
      //itemCount: products.length,
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
                        title: Text(products[index].product_name),
                        subtitle: (Text(products[index].brand_name + "\n" + products[index].subhead + products[index].description)),
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
}
