import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:ice_cream_social/backend_data.dart';

/// The [Statistics] page allows admin users to view statistics about the ice cream data.
/// Currently it supports two advanced SQL queries.

class StatisticsPage extends StatefulWidget {
  StatisticsPage();

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // Used for testing. Will be deleted once SQL integration is set up.
  Future<List<Object>> futureListItems;
  List<Object> listItems;
  List<String> queryTitles = ["Anna's Query", "Hannah's Query"];
  bool showList;
  String query;
  BackendData providerBackendData;
  String url;
  String username;
  String password;

  @override
  initState() {
    listItems = [];
    showList = false;
    query = queryTitles[0];
    providerBackendData = Provider.of<BackendData>(
      context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;
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
    return FutureBuilder<List<String>>(
      future: futureListItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          listItems = snapshot.data;
          return Card(
            color: Colors.purple,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                listItems[index],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error getting ingredients data");
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
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
    futureListItems = fetchQuery();
    showList = true;
    setState(() {});
  }

  Future<List<String>> fetchQuery() async {
    String path = query == "Anna's Query" ? "aadvanced" : "hadvanced";
    // final response =
    //     await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(Uri.http(url, path), headers: {
      "Accept": "application/json",
      'authorization': basicAuth,
    });

    log("statistics response body: " + response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> results = (data).map((i) => mapper(i)).toList();
      for (String x in results) {
        log("x is: " + x);
      }
      listItems = results;
      return results;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  String mapper(Map<String, dynamic> json) {
    if (query == "Anna's Query") {
      return json['product_id'].toString() +
          " " +
          json['brand'].toString() +
          " " +
          json['averageRating'].toString() +
          " " +
          json['numReviews'].toString();
    } else {
      String result = json['username'].toString() +
          " " +
          json['five_star_reviews'].toString();
      return result;
    }
  }
}
