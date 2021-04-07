import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ice_cream_social/SettingsPage/ingredient.dart';
import './ingredients_admin.dart';

/// The [Settings] page widget describes the screen representing an ice cream flavor, all of its reviews,
/// and a floating action button. The floating action button triggers a fab which allows the user to
/// add a review if they haven't done so yet, or edit the review they've already added.
///
/// Specifically, [FlavorPage] combines the [FlavorInfo] + [ReviewDialog] widgets.
/// See example_flavor_page, an example of how to combine [FlavorPage] with the rest of an application.

class StatisticsPage extends StatefulWidget {
  StatisticsPage({signOut});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Object> listItems = [
    "cat",
    "dog",
    "horse",
    "zebra",
    "tiger",
  ];
  List<String> queryTitles = ["Anna's Query", "Hannah's Query"];
  bool showList;
  String query;

  @override
  initState() {
    showList = false;
    query = queryTitles[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text(
        'ADMIN: Statistics',
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

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: listItems.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return getRadioButtons();
        else
          return getItemWidget(index - 1);
      },
    );
  }

  Widget getItemWidget(index) {
    return Visibility(
      visible: showList,
      child: Card(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listItems[index],
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget getRadioButtons() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(queryTitles[0]),
          leading: Radio(
            value: queryTitles[0],
            groupValue: query,
            onChanged: (String value) {
              setState(() {
                query = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(queryTitles[1]),
          leading: Radio(
            value: queryTitles[1],
            groupValue: query,
            onChanged: (String value) {
              setState(() {
                query = value;
              });
            },
          ),
        ),
        ElevatedButton(
          child: Text("Run!"),
          onPressed: runQuery,
        )
      ],
    );
  }

  void runQuery() {
    showList = true;
    setState(() {});
  }
}
