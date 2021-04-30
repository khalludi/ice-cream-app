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
class StatisticsGradesPage extends StatefulWidget {
  StatisticsGradesPage();

  @override
  _StatisticsGradesPageState createState() => _StatisticsGradesPageState();
}

class _StatisticsGradesPageState extends State<StatisticsGradesPage> {
  // Used for testing. Will be deleted once SQL integration is set up.
  Future<dynamic> response;
  List<dynamic> userGrades;
  List<dynamic> productGrades;

  BackendData providerBackendData;
  String url;
  String username;
  String password;

  @override
  initState() {
    userGrades = [];
    productGrades = [];
    providerBackendData = Provider.of<BackendData>(
      context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;
    response = fetchQuery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: response,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildScaffold(context);
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: _buildBar(context),
            body: Center(
              child: Text("Error getting ingredients data"),
            ),
          );
        }
        // By default, show a loading spinner.
        return Scaffold(
          appBar: _buildBar(context),
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: buildTables(context),
    );
  }

  Widget buildTables(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                'Product Grade (avg rating)',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Number of Products',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text(
                    (productGrades[2]["ratingGrade"] + (" ie <5 reviews")))),
                DataCell(Text(productGrades[2]["COUNT(*)"].toString())),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text((productGrades[3]["ratingGrade"]))),
                DataCell(Text((productGrades[3]["COUNT(*)"].toString()))),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text((productGrades[1]["ratingGrade"]))),
                DataCell(Text((productGrades[1]["COUNT(*)"].toString()))),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text((productGrades[0]["ratingGrade"]))),
                DataCell(Text((productGrades[0]["COUNT(*)"].toString()))),
              ],
            ),
          ],
        ),
        DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                'User Grade (reviews written)',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Number of Users',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text((userGrades[1]["userGrade"]))),
                DataCell(Text((userGrades[1]["COUNT(username)"].toString()))),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text((userGrades[2]["userGrade"]))),
                DataCell(Text((userGrades[2]["COUNT(username)"].toString()))),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text((userGrades[3]["userGrade"]))),
                DataCell(Text((userGrades[3]["COUNT(username)"].toString()))),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text((userGrades[0]["userGrade"]))),
                DataCell(Text((userGrades[0]["COUNT(username)"].toString()))),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text(
        'User, Product Grades',
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

  Widget _buildBody(BuildContext context) {}

  Future<dynamic> fetchQuery() async {
    final response = await http.get(
        Uri.https(
          url,
          "call-procedure",
        ),
        headers: {
          "Accept": "application/json",
        });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      productGrades = data[0];
      userGrades = data[1];
    }
    return response;
  }
}
