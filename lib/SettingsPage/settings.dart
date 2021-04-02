import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ice_cream_social/SettingsPage/ingredient.dart';
import './ingredients_admin.dart';

/// The [FlavorPage] widget describes the screen representing an ice cream flavor, all of its reviews,
/// and a floating action button. The floating action button triggers a fab which allows the user to
/// add a review if they haven't done so yet, or edit the review they've already added.
///
/// Specifically, [FlavorPage] combines the [FlavorInfo] + [ReviewDialog] widgets.
/// See example_flavor_page, an example of how to combine [FlavorPage] with the rest of an application.

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

  // TODO: add logout
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
      'text': 'Log Out ',
      'isTitle': false,
      'route': null,
    },
  ];

  void handleRoute(Widget Function() route) {
    if (route != null) {
      // const durationMillisec = 20;
      // Offset offset = const Offset(5, 0);
      // Navigator.of(context).push(
      //   new PageRouteBuilder(
      //     opaque: true,
      //     transitionDuration: const Duration(milliseconds: durationMillisec),
      //     pageBuilder: (BuildContext context, _, __) {
      //       return route();
      //     },
      //     transitionsBuilder:
      //         (_, Animation<double> animation, __, Widget child) {
      //       return new SlideTransition(
      //         child: child,
      //         position: new Tween<Offset>(
      //           begin: offset,
      //           end: Offset.zero,
      //         ).animate(animation),
      //       );
      //     },
      //   ),
      // );
      Navigator.push(context, CupertinoPageRoute(builder: (_) => route()));
    }
  }

  // routeIngredients returns
  Widget routeIngredients() {
    return IngredientsAdmin(
      ingredients: ingredients,
    );
  }

  Widget buildBody(BuildContext ctxt, int index) {
    if (litems[index]['isTitle']) {
      return Text(litems[index]['text']);
    } else {
      return new Card(
        child: ElevatedButton(
          onPressed: () {
            if (litems[index]['text'] == "Modify Ingredients")
              handleRoute(routeIngredients);
            else if (litems[index]['text'] == "Log Out") {
              widget.signOut();
              Navigator.pop(context);
            }
          },
          child: Text(litems[index]['text']),
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
