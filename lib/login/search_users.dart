import 'dart:math';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class User {
  final String username;
  final String email;

  User(this.username, this.email);
}

class _SearchUsersState extends State<SearchUsers> {
  final SearchBarController<User> _searchBarController = SearchBarController();

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

  Future<List<User>> _getAllUsers(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    if (text.length == 5) throw Error();
    if (text.length == 6) return [];
    List<User> posts = [];

    var random = new Random();
    for (int i = 0; i < 10; i++) {
      // posts.add(User("$text $i", "body random number : ${random.nextInt(100)}"));
      posts.add(User("user_bobby", "dana.drow@gmail.com"));
    }
    return posts;
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
