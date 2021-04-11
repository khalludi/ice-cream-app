import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice_cream_social/FlavorPage/flavor_page.dart';
import 'package:ice_cream_social/FlavorPage/review.dart';
import 'IngredientsPage/ingredients_admin.dart';
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
  SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  initState() {
    super.initState();
  }

  List<Map<String, Object>> settingOptions = [
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
      'text': "View Example Flavor Page",
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

    if (settingOptions[index]['text'] == "Modify Ingredients")
      route = routeIngredients;
    else if (settingOptions[index]['text'] == "Log Out") {
      Navigator.pop(context);
    } else if (settingOptions[index]['text'] == "View Statistics") {
      route = routeStatistics;
    } else if (settingOptions[index]['text'] == "View Example Flavor Page") {
      route = routeFlavorPage;
    }
    if (route != null)
      Navigator.push(context, CupertinoPageRoute(builder: (_) => route()));
  }

  Widget routeIngredients() {
    return IngredientsAdmin();
  }

  Widget routeStatistics() {
    return StatisticsPage();
  }

  final _reviews = [
    Review(
      author: 'Krisg0531',
      date_updated: '2019-12-27',
      title: 'No oreos!!!!',
      stars: 1,
      helpful_yes: 5,
      helpful_no: 0,
      review_text:
          'If I wanted vanilla ice cream I would have purchased it. Dug through in hopes of finding some oreos... no luck. And obviously this an on going issue from what I read of other reviews.',
      is_editable: false,
    ),
    Review(
      author: 'amh88',
      date_updated: '2018-08-06',
      title: 'Where\'s the oreo?',
      stars: 1,
      helpful_yes: 8,
      helpful_no: 2,
      review_text:
          'So disappointed. I probably got 2 maybe 3 tiny little pieces of oreo. Its more like crumbs not pieces.',
      is_editable: false,
    ),
    Review(
      author: 'Username286399371',
      title: 'Discolored ice cream',
      date_updated: '2020-06-17',
      stars: 1,
      helpful_yes: 0,
      helpful_no: 0,
      review_text:
          'I had bought the cookies an cream ice cream but upon opening it appeared to be a totally different thing. The ice cream appears to be discolored even though the container seemed intact and untampered. It does not appear to be a miss branded chocolate version of the cookies and cream but appears to be dyed with black food dye. It looks unappetizing and inedible. I have had the brand before and have never encountered this problem.',
      is_editable: false,
    ),
    Review(
      author: 'leash998',
      title: 'Oreo\'s Ice Cream without the Oreo\'s',
      date_updated: '2020-08-21',
      stars: 1,
      helpful_yes: 0,
      helpful_no: 0,
      review_text:
          'This was one of those late nights I was craving cookies and cream and went out to 7Eleven to pick this up. Was so disappointed! There was none, I mean ZERO cookies/Oreo\'s in this! It was straight vanilla ice cream and nothing more. I thought there might be more at the bottom? NOPE! Just more vanilla ice cream...',
      is_editable: false,
    ),
    Review(
      author: 'Mariet',
      title: 'OK',
      date_updated: '2020-03-15',
      stars: 2,
      helpful_yes: 3,
      helpful_no: 0,
      review_text:
          'It’s a great flavors, WHEN there are actual cookies in it, and not just a rub of Vanilla ice cream.',
      is_editable: false,
    ),
    Review(
      author: 'OreoBaby',
      title: 'Horrible',
      date_updated: '2019-02-24',
      stars: 1,
      helpful_yes: 4,
      helpful_no: 1,
      review_text:
          'I was getting over a break up and i got this icecream to feel better and it\'s just made me more sad then ever when I saw there was no Oreo inside I was expecting 20% more cookies, but no it\’s just plain icecream . #findingtheoreo',
      is_editable: false,
    )
  ];
  Widget routeFlavorPage() {
    return FlavorPage(
      flavorName: "Cookies and Cream",
      productId: 15,
      brand: "Breyers",
      description:
          "Breyers? vanilla and heaps of OREO? cookies? Yes please! If you?re anything like us, you love Breyers? vanilla and OREO? cookies. So why not combine your love into one tub with Breyers? OREO? Cookies & Cream? Rich, creamy vanilla goodness surrounds those chunks of 100% REAL OREO? cookies and will be sure to bring a smile to your face.",
      pngFile: "15_breyers.png",
      passedReviews: _reviews,
      context: context,
    );
  }

  Widget buildBody(BuildContext ctxt, int index) {
    bool shouldIncludeIcon = settingOptions[index]['text'] != 'Log Out';
    if (settingOptions[index]['isTitle']) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
        child: Text(
          settingOptions[index]['text'],
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
                      settingOptions[index]['text'],
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
    return Scaffold(
      appBar: _buildBar(context),
      body: new ListView.builder(
        itemCount: settingOptions.length,
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
