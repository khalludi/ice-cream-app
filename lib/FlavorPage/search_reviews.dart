import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:ice_cream_social/FlavorPage/review.dart';
import 'package:ice_cream_social/FlavorPage/review_card.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ice_cream_social/backend_data.dart';

class SearchReviews extends StatefulWidget {
  int productId;
  String brand;
  BuildContext context;

  SearchReviews({
    @required this.productId,
    @required this.brand,
    @required this.context,
  });

  @override
  _SearchReviewsState createState() => _SearchReviewsState();
}

class _SearchReviewsState extends State<SearchReviews> {
  int productId;
  String brand;
  BackendData providerBackendData;
  String url;
  String username;
  String password;

  @override
  void initState() {
    brand = widget.brand;
    productId = widget.productId;
    log("initState productId=" + productId.toString());
    providerBackendData = Provider.of<BackendData>(
      context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;
    super.initState();
  }

  Future<List<Review>> searchReviews(String query) async {
    log("productId: " + widget.productId.toString());
    var queryParameters = {
      'search_term': query,
      'productId': widget.productId.toString(),
      'brand': widget.brand,
    };

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
      Uri.http(
        url,
        "reviews/text",
        queryParameters,
      ),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Review> ingredients = (data).map((i) => Review.fromJson(i)).toList();
      return ingredients;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: buildSearchBar(context),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text(
        'Search Reviews',
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

  @override
  Widget buildSearchBar(BuildContext context) {
    return SearchBar(
      searchBarPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      listPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      shrinkWrap: true,
      hintText: "Search review content!",
      onItemFound: (item, int index) {
        return ReviewCard(
          review: item,
          index: index,
          allowEditing: false,
        );
      },
      onSearch: searchReviews,
    );
  }
}
