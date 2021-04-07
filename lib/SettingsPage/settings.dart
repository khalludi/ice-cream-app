import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ice_cream_social/SettingsPage/ingredient.dart';
import './ingredients_admin.dart';
import './statistics.dart';

/// The [Settings] page widget enables the user to change their system preferences.
/// Admin users can access the modify ingredients page and statistics page.
///
/// Note: the ingredients and litems lists are used for testing purposes but they
/// will be removed once SQL integration is set up.

int buildNumber = 0;
typedef Callback = Function(int);
typedef Callback2 = Function(String);

class SettingsPage extends StatefulWidget {
  Function signOut;
  SettingsPage({signOut});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  initState() {
    super.initState();
  }

  List<Ingredient> ingredients = [
    Ingredient(
      name: "vanilla",
      id: 1,
    ),
    Ingredient(
      name: "chocolate",
      id: 2,
    ),
    Ingredient(
      name: "heavy cream",
      id: 3,
    ),
    Ingredient(
      name: "almonds",
      id: 4,
    ),
    Ingredient(
      name: "peanut butter",
      id: 5,
    ),
    Ingredient(
      name: "sugar",
      id: 6,
    ),
    Ingredient(
      name: "molasses",
      id: 7,
    ),
    Ingredient(
      name: "strawberries",
      id: 8,
    ),
    Ingredient(
      name: "skim milk",
      id: 9,
    ),
  ];

  List<Map<String, Object>> litems = [
    {
      'text': "Admin",
      'isTitle': true,
      'route': null,
    },
    {
      'text': "Modify Products",
      'isTitle': false,
      'route': null,
    },
    {
      'text': "Modify Ingredients",
      'isTitle': false,
      'route': null,
    },
    {
      'text': "View Statistics",
      'isTitle': false,
      'route': null,
    },
    {
      'text': "Account",
      'isTitle': true,
      'route': null,
    },
    {
      'text': 'Language',
      'isTitle': false,
      'route': null,
    },
    {
      'text': 'Notifications',
      'isTitle': false,
      'route': null,
    },
    {
      'text': 'Sound',
      'isTitle': false,
      'route': null,
    },
    {
      'text': 'Help',
      'isTitle': true,
      'route': null,
    },
    {
      'text': 'Contact Us',
      'isTitle': false,
      'route': null,
    },
    {
      'text': 'Log Out',
      'isTitle': false,
      'route': null,
    },
  ];

  void handleRoute(int index) {
    Widget Function() route;

    if (litems[index]['text'] == "Modify Ingredients")
      route = routeIngredients;
    else if (litems[index]['text'] == "Log Out") {
      widget.signOut();
      Navigator.pop(context);
    } else if (litems[index]['text'] == "View Statistics") {
      route = routeStatistics;
    }
    if (route != null)
      Navigator.push(context, CupertinoPageRoute(builder: (_) => route()));
  }

  // routeIngredients returns
  Widget routeIngredients() {
    return IngredientsAdmin(
      passedIngredients: ingredients,
    );
  }

  // routeIngredients returns
  Widget routeStatistics() {
    return StatisticsPage();
  }

  Widget buildBody(BuildContext ctxt, int index) {
    bool shouldIncludeIcon = litems[index]['text'] != 'Log Out';
    if (litems[index]['isTitle']) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
        child: Text(
          litems[index]['text'],
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Nexa',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ButtonTheme(
          padding: EdgeInsets.symmetric(
            vertical: 0.0,
          ), //adds padding inside the button
          materialTapTargetSize: MaterialTapTargetSize
              .shrinkWrap, //limits the touch area to the button area
          minWidth: 0, //wraps child's width
          height: 0, //wraps child's height
          child: ElevatedButton(
            onPressed: () => handleRoute(index),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      litems[index]['text'],
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: shouldIncludeIcon
                        ? Icon(Icons.arrow_forward_ios_rounded)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    buildNumber += 1;
    log("Rebuild FlavorPage: $buildNumber times");
    return Scaffold(
      appBar: _buildBar(context),
      body: new ListView.builder(
        itemCount: litems.length,
        itemBuilder: (BuildContext ctxt, int index) => buildBody(ctxt, index),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text(
        'Settings',
        style: TextStyle(
          fontFamily: 'Nexa',
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Colors.purple, Colors.blue],
          ),
        ),
      ),
    );
  }
}
