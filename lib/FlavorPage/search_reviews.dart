import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:ice_cream_social/FlavorPage/review.dart';
import 'package:ice_cream_social/FlavorPage/review_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class SearchReviews extends StatelessWidget {
  int productId;
  int brandId;
  String url = '192.168.0.7:8080';

  SearchReviews({
    Key key,
    @required productId,
    @required brandId,
  }) : super(key: key);

  Future<List<Review>> searchReviews(String query) async {
    var queryParameters = {
      'productId': productId,
      'brand': brandId,
      'text': query,
    };

    final response = await http.get(
      Uri.http(
        url,
        "reviews/test", //TODO: pass in specific brand and productId
        queryParameters,
      ),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data['reviews'] as List;
      Review review = Review.fromJson(rest[0]);
      List<Review> reviews = (rest).map((i) => Review.fromJson(i)).toList();
      await Future.delayed(Duration(seconds: 2));
      return reviews;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log("ERROR!!!!");
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
