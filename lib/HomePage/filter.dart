import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../main.dart';
import 'Products.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:ice_cream_social/backend_data.dart';
import 'Products.dart';

void main() {
  runApp(new MyApp());
}

class FilterPage extends StatefulWidget {
  BuildContext context;
  FilterPage({ this.context });
  _FilterPageState createState() => new _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  //used to toggle design of brand buttons
  bool _hasBeenPressed1 = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;
  bool _hasBeenPressed4 = false;

  double filterRating;
  List<String> filterBrand;

  BackendData providerBackendData;
  String url;
  String username;
  String password;
  List<Products> productsFiltered;

  @override
  void initState() {
    providerBackendData = Provider.of<BackendData>(
        widget.context,
        listen: false
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;

    filterRating = 0.0;
    filterBrand = [];
  }

   void filterProducts(double filterRating, List<String> filterBrand) async {
    String brand_cols = "";
    int first = 1;
    for (String val in filterBrand) {
      if (first == 1) {
        brand_cols += val;
        first = 0;
      } else {
        brand_cols += ',';
        brand_cols += val;
      }
    }

    var queryParameters = {"filter_rating": filterRating.toString(), "filter_brand": brand_cols};
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(Uri.https(url, "filter-product", queryParameters), headers: {
      "Accept": "application/json",
      'authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    });
    print(Uri.https(url, "filter-product", queryParameters));
    print(queryParameters);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Products> products =
      (data).map((i) => Products.fromJson(i)).toList();
      //return products;
      setState(() {
        productsFiltered = products;
      });
      for(Products p in productsFiltered){
        print(p.brand_name);
      }
      print("*****************************");
      Navigator.pop(context, productsFiltered);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Fail");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Minimum Rating',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Lato', fontSize: 30),
              ),
            ),

            /**Feature to allow users to filter by rating.**/
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              //direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              itemBuilder: (context, _) =>
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              onRatingUpdate: (rating) {
                filterRating = rating;
                print(filterRating);
              },
            ),
            SizedBox(height: 100),  //used to space out components

            /**Feature to allow users to filter by brands.**/
            /**Originally used ElevatedButton because RaisedButton dep, but issues !!!**/
            Container(
              child: Text(
                'Brand',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Lato', fontSize: 30),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: RaisedButton(
                //toggle button design between on/off
                onPressed: () =>
                {
                  setState(() {
                    _hasBeenPressed1 = !_hasBeenPressed1;
                    if (_hasBeenPressed1 == true){
                      filterBrand.add('bj');
                    }
                  }),
                },
                padding: EdgeInsets.all(0.0),
                shape: StadiumBorder(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        //toggle colors
                        colors: _hasBeenPressed1 ? <Color>[Colors.purple,Colors.orange,] : <Color>[Colors.white, Colors.white]
                    ),
                  ),
                  //toggle text colors
                  child: Text('Ben & Jerry\'s', style: TextStyle(color: _hasBeenPressed1 ? Colors.white : Colors.black, fontFamily: 'Lato', fontSize: 20.0)),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: () =>
                {
                  setState(() {
                    _hasBeenPressed2 = !_hasBeenPressed2;
                    if (_hasBeenPressed2 == true){
                      filterBrand.add('breyers');
                    }
                  }),
                },
                padding: EdgeInsets.all(0.0),
                shape: StadiumBorder(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _hasBeenPressed2 ? <Color>[Colors.purple,Colors.orange,] : <Color>[Colors.white, Colors.white])
                  ),
                  child: Text('Breyers', style: TextStyle(color: _hasBeenPressed2 ? Colors.white : Colors.black, fontFamily: 'Lato', fontSize: 20.0)),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: () =>
                {
                  setState(() {
                    _hasBeenPressed3 = !_hasBeenPressed3;
                    if (_hasBeenPressed3 == true){
                      filterBrand.add('hd');
                    }
                  }),
                },
                padding: EdgeInsets.all(0.0),
                shape: StadiumBorder(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _hasBeenPressed3 ? <Color>[Colors.purple,Colors.orange,] : <Color>[Colors.white, Colors.white]),
                  ),
                  child: Text('Häagen-Dazs', style: TextStyle(color: _hasBeenPressed3 ? Colors.white : Colors.black, fontFamily: 'Lato', fontSize: 20.0)),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: () =>
                {
                  setState(() {
                    _hasBeenPressed4 = !_hasBeenPressed4;
                    if (_hasBeenPressed4 == true){
                      filterBrand.add('talenti');
                    }
                  }),
                },
                padding: EdgeInsets.all(0.0),
                shape: StadiumBorder(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _hasBeenPressed4 ? <Color>[Colors.purple,Colors.orange,] : <Color>[Colors.white, Colors.white])
                  ),
                  child: Text('Talenti', style: TextStyle(color: _hasBeenPressed4 ? Colors.white : Colors.black, fontFamily: 'Lato', fontSize: 20.0)),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
              ),
            ),
            SizedBox(height:100),

            /**When users are done, they are navigated back to home screen.**/
            Container(
              child: RaisedButton(
                onPressed: (){
                  print(filterRating);
                  filterProducts(filterRating, filterBrand);
                },
                padding: EdgeInsets.all(0.0),
                shape: StadiumBorder(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Colors.purple,
                            Colors.blue
                          ])
                  ),
                  child: Text(
                      'DONE',
                      style: TextStyle(color: Colors.white, fontFamily: 'Lato', fontSize: 25.0)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**Navigate back to Home Page.**/
  /**
   * QUESTION: Call SQL instance from here or pass selected list back to Home?
   */
  Future navigateToHome(context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  /**
   * REPEATED CODE: look into applying app bar acros all screens!!!
   */
  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text('ICE CREAM SOCIAL',
          style: TextStyle(fontFamily: 'Lato', fontSize: 30)),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.purple,
                  Colors.blue
                ])
        ),
      ),
    );
  }
}