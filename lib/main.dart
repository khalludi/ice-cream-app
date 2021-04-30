import 'dart:convert';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ice_cream_social/HomePage/search.dart';
import 'package:ice_cream_social/backend_data.dart';
import 'package:ice_cream_social/login/authentication.dart';
import 'package:ice_cream_social/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'HomePage/Products.dart';
import 'HomePage/filter.dart';
import 'FlavorPage/flavor_page.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
            create: (context) => BackendData(),
            child: MaterialApp(
              home: HomePage()
            ),
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Products>> futureProducts;
  List<Products> products;
  List<Products> filteredProducts;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<Products> searchResults;
  BackendData providerBackendData;
  String url;
  String username;
  String password;
  bool isUsingSearchBar;

  Map<String, String> brandIdMap = {
    'breyers': 'Breyers',
    'bj': 'Ben & Jerry\'s',
    'talenti': 'Talenti',
    'hd': 'Haagen Daaz',
  };

  @override
  void initState() {
    providerBackendData = Provider.of<BackendData>(
      context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;
    isUsingSearchBar = false;
    futureProducts = fetchProducts();
    toProfile = 0;
    super.initState();
  }
  int _selectedIndex = 0;
  int loginChanged = 0;
  int toProfile;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Lato');

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

  void updateToProfile(int newId) {
    toProfile = newId;
    print("Updated toProfile to $toProfile\n");
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

  Widget HomeDisplay({BuildContext context}){
    List<Products> p;
    if(filteredProducts != null){
      p = filteredProducts;
    } else{
      p = products;
    }
    return Scaffold(
        appBar: _buildBar(context),
      body: SearchBar<Products>(
        key: scaffoldKey,
        searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
        headerPadding: EdgeInsets.symmetric(horizontal: 10),
        // listPadding: EdgeInsets.symmetric(horizontal: 10),
        // mainAxisSpacing: 10,
        searchBarStyle: SearchBarStyle(
            padding: EdgeInsets.only(left: 15),
            borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        listPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          // vertical: 10,
        ),
        suggestions: p,
        onCancelled: () => isUsingSearchBar = false,
        hintText: "Search",
        shrinkWrap: true,
        onSearch: search,
        onItemFound: (Products product, int index) {
          return getProductsWidget(product);
        },
      ),
      /**
          Expanded(
          child: IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
          //navigateToFilter(context);
          }),
          ),
       **/
      floatingActionButton: Builder(
      builder: (context) => FloatingActionButton(
      onPressed: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FilterPage(context: context)))
            .then((completion){

          setState(() {
            filteredProducts = completion;
          });
        });
        /**
        List<Products> filteredProducts = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => FilterPage(context: context)));
        print("here");
        print(filteredProducts);
        setState(() {
          for(Products p in filteredProducts){
            getProductsWidget(p);
          }
        });**/
      },
      child: Icon(Icons.filter_list),
      backgroundColor: Colors.purple,
      ),
      ),
    );
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
      List<Products> products =
      (data).map((i) => Products.fromJson(i)).toList();
      return products;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Fail");
    }
    return null;
  }

  Widget buildSearch(BuildContext context) {
    return FutureBuilder<List<Products>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          products = snapshot.data;
          print(products);
          return HomeDisplay(context: context);
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
          body: Center(child: CircularProgressIndicator()),
          appBar: _buildBar(context),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    Authentication auth = new Authentication();
    _widgetOptions = [];
    _widgetOptions.add(buildSearch(context));
    _widgetOptions.add(LoginScreen(
      onLoginChanged: updateLoginChanged,
      auth: auth,
      context: context,
      toProfile: toProfile,
      onProfileChanged: updateToProfile,
    ));

    return MaterialApp(
      home: Scaffold(
        // appBar: _buildBar(context),
        body: Builder(
            builder: (context) => chooseWidget(context)
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

  Future<List<Products>> search(String query) async {
    isUsingSearchBar = true;
    String s = query;
    searchResults = products
        .where((b) => b.product_name.toLowerCase().contains(s.toLowerCase()) || b.description.toLowerCase().contains(s.toLowerCase()))
        .toList();
    return searchResults;
  }

  Widget getProductsWidget(Products product) {
    return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title:  Text(
                product.product_name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: (Text(product.brand_name + "\n" + product.subhead + product.description + "\nAvg. Rating: " + product.avg_rating.toString())),
            ),
            ButtonTheme(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('See More'),
                    onPressed: () => routeFlavorPage(context, product),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  void routeFlavorPage(BuildContext context, Products product) {
    Widget route = FlavorPage(
      flavorName: product.product_name,
      productId: product.product_id,
      brand: product.brand_name,
      description: product.description,
      pngFile: null,
      context: context,
      avgRating: product.avg_rating,
    );
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
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
}
