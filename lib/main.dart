import 'package:flutter/material.dart';
import 'package:ice_cream_social/HomePage/search.dart';
import 'package:ice_cream_social/login/login_screen.dart';
import 'package:ice_cream_social/login/profile.dart';
import 'HomePage/filter.dart';
import 'HomePage/placeholder_widget.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  int _selectedIndex = 0;
  int loginChanged = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Lato');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    return MaterialApp(
      home: Scaffold(
        appBar: _buildBar(context),
        body: Padding(
            child: FutureBuilder<List<Photo>>(
              future: fetchPhotos(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? PhotosList(photos: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
            padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
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

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
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
                        leading: Image.network(
                          photos[index].thumbnailUrl,
                          fit: BoxFit.fitWidth,
                        ),
                        title: Text(photos[index].title),
                        subtitle: Text(photos[index].title),
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

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
  await client.get('https://jsonplaceholder.typicode.com/photos');

// Use the compute function to run parsePhotos in a separate isolate
  return compute(parsePhotos, response.body);
}

// A function that will convert a response body into a List<Photo>
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}
