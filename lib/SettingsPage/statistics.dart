import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ice_cream_social/SettingsPage/ingredient.dart';
import './ingredients_admin.dart';

/// The [Statistics] page allows admin users to view statistics about the ice cream data.
/// Currently it supports two advanced SQL queries.

class StatisticsPage extends StatefulWidget {
  StatisticsPage();

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // Used for testing. Will be deleted once SQL integration is set up.
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
