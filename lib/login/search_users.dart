import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ice_cream_social/backend_data.dart';
import 'package:provider/provider.dart';

class SearchUsers extends StatefulWidget {
  SearchUsers({
    @required this.context,
  });

  final BuildContext context;

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class User {
  final String username;
  final String email;

  User(this.username, this.email);

  factory User.fromJson(dynamic json) {
    return User(json['username'] as String, json['email'] as String);
  }
}

class _SearchUsersState extends State<SearchUsers> {
  final SearchBarController<User> _searchBarController = SearchBarController();

  BackendData providerBackendData;
  String url;

  @override
  void initState() {
    providerBackendData = Provider.of<BackendData>(
      widget.context,
      listen: false,
    );
    url = providerBackendData.url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: SearchBar<User>(
          onSearch: _getAllUsers,
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          // listPadding: EdgeInsets.symmetric(horizontal: 10),
          // mainAxisSpacing: 10,
          searchBarStyle: SearchBarStyle(
            padding: EdgeInsets.only(left: 15),
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          // indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
          emptyWidget: Center(
            child: Text(
              "Nothing\nFound!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Lato",
                fontWeight: FontWeight.w900,
                fontSize: 70,
              ),
            ),
          ),
          onItemFound: (User post, int index) {
            return Container(
              child: ListTile(
                title: Text(post.username),
                // isThreeLine: true,
                subtitle: Text(post.email),
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
                },
              ),
            );
          },
        )
      )
    );
  }

  Future<http.Response> fetchAlbum(String searchTerm) {
    var queryParameters = {
      "search_term" : searchTerm,
    };
    return http.get(Uri.https(url, 'user-search', queryParameters));
  }

  Future<List<User>> _getAllUsers(String text) async {
    var response;
    try {
      response = await fetchAlbum(text);
    } on SocketException catch (e) {
      print('error ${e}');
    } catch (e) {
      //for other errors
      print('error ${e.toString()}');
    }

    print(response);

    var tagObjsJson = jsonDecode(response.body) as List;
    List<User> tagObjs = tagObjsJson.map((tagJson) => User.fromJson(tagJson)).toList();

    print(tagObjs);

    return tagObjs;
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text('User Search',
          style: TextStyle(fontFamily: 'Nexa', fontSize: 28, fontWeight: FontWeight.w700)),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.purple, Colors.blue])),
      )
    );
  }
}
