import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'flavor_info.dart';
import 'review.dart';
import 'review_dialog.dart';
import 'package:intl/intl.dart';
import 'package:ice_cream_social/backend_data.dart';

/// The [FlavorPage] widget describes the screen representing an ice cream flavor, all of its reviews,
/// and a floating action button. The floating action button triggers a fab which allows the user to
/// add a review if they haven't done so yet, or edit the review they've already added.
///
/// Specifically, [FlavorPage] combines the [FlavorInfo] + [ReviewDialog] widgets.
/// See example_flavor_page, an example of how to combine [FlavorPage] with the rest of an application.

int buildNumber = 0;
typedef Callback = Function(int);
typedef Callback2 = Function(String);

class FlavorPage extends StatefulWidget {
  FlavorPage({
    Key key,
    @required this.flavorName,
    @required this.productId,
    @required this.brand,
    @required this.description,
    @required this.pngFile,
    @required this.context,
  });

  final String flavorName;
  final int productId;
  final String brand;
  final String description;
  final String pngFile;
  final BuildContext context;

  @override
  _FlavorPageState createState() => _FlavorPageState();
}

class _FlavorPageState extends State<FlavorPage> {
  Future<List<Review>> futureReviews;
  List<Review> reviews;
  String brandId;
  bool hasAddedReview = false;
  Map<String, String> brandIdMap = {
    'Breyers': 'breyers',
    'Ben & Jerry\'s': 'bj',
    'Talenti': 'talenti',
    'Haagen Daaz': 'hd',
  };
  BackendData providerBackendData;
  String url;
  String username;
  String password;

  @override
  void initState() {
    brandId = brandIdMap[widget.brand];
    providerBackendData = Provider.of<BackendData>(
      widget.context,
      listen: false,
    );
    url = providerBackendData.url;
    username = providerBackendData.username;
    password = providerBackendData.password;
    futureReviews = fetchReviews();
    super.initState();
  }

  Future<List<Review>> fetchReviews() async {
    var queryParameters = {
      'productId': widget.productId,
      'brand': brandId,
    };
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
      Uri.http(
        url,
        "reviews",
      ),
      headers: {
        "Accept": "application/json",
        'authorization': basicAuth,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Review> reviews = (data).map((i) => Review.fromJson(i)).toList();
      return reviews;
    } else {}
    return null;
  }

  void addReview(review) {
    hasAddedReview = true;
    reviews.insert(
      0,
      Review(
        date_updated: review.date_updated,
        author: review.author,
        title: review.title,
        review_text: review.review_text,
        stars: review.stars,
        helpful_no: review.helpful_no,
        helpful_yes: review.helpful_yes,
        is_editable: true,
      ),
    );
    setState(() {});
    final snackBar = SnackBar(content: Text('Added review!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    addReviewToDatabase(review);
  }

  void addReviewToDatabase(review) async {
    Map data = {
      'review_id': 100,
      'product_id': widget.productId,
      'brand': brandId,
      'author': review.author,
      // TODO: figure out datetime stuff
      'date_updated': DateFormat('yyyy-mm-dd').format(review.date_updated),
      'stars': review.stars,
      'helpful_yes': review.helpful_yes,
      'helpful_no': review.helpful_no,
    };
    String body = json.encode(data);
    http.Response response = await http.post(
      Uri.http(
        url,
        "/reviews",
      ),
      headers: {"Accept": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
    } else {}
  }

  void createEditDialog(int index) async {
    List<Object> result = await showDialog(
        context: context,
        builder: (_) => ReviewDialog(context: context, review: reviews[index]));
    Review review = result[0];
    int action = result[1];
    if (action == 1)
      editReview(review, index);
    else if (action == 2) deleteReview(review, index);
  }

  void deleteReview(Review review, int index) {
    reviews.removeAt(0);
    hasAddedReview = false;
    setState(() {});
    final snackBar = SnackBar(content: Text('Deleted review!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    deleteReviewFromDatabase(review);
  }

  void deleteReviewFromDatabase(Review review) async {
    var queryParameters = {
      'review_id': review.review_id,
      'brand': brandIdMap[review.brand],
    };
    http.Response response = await http.delete(
      Uri.http(
        url,
        "reviews/${review.review_id}",
        queryParameters,
      ),
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
    } else {}
  }

  void editReview(newReview, index) {
    reviews[index] = Review(
      date_updated: newReview.date_updated,
      author: newReview.author,
      title: newReview.title,
      review_text: newReview.review_text,
      stars: newReview.stars,
      helpful_no: newReview.helpful_no,
      helpful_yes: newReview.helpful_yes,
      is_editable: newReview.is_editable,
    );
    setState(() {});
    final snackBar = SnackBar(content: Text('Edited review!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void editReviewInDatabase(Review review) async {
    var data = {
      'review_id': (reviews.length + 1).toString(),
      'author': review.author,
    };
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    String body = json.encode(data);
    http.Response response = await http.post(
      Uri.http(
        url,
        "ingredients",
      ),
      headers: {
        // "Accept": "application/json",
        'authorization': basicAuth,
      },
      body: body,
    );
    if (response.statusCode == 200) {
      print("ingredientAdmin success");
      var data = json.decode(response.body);
    } else {
      print("ingredientAdmin fail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: futureReviews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          reviews = snapshot.data;
          return buildScaffold(context);
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: _buildBar(context),
            body: Center(
              child: Text("Error getting reviews"),
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

  @override
  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.grey[300],
      appBar: _buildBar(context),
      body: FlavorInfo(
        flavor: widget.flavorName,
        productId: widget.productId,
        brand: widget.brand,
        flavorImageUrl: widget.pngFile,
        description: widget.description,
        passedReviews: reviews,
        avgRating: 2.5,
        createEditDialog: createEditDialog,
      ),
      floatingActionButton: Visibility(
        visible: !hasAddedReview,
        child: Builder(
          builder: (context) => FloatingActionButton(
            heroTag: null,
            onPressed: () async {
              List<Object> result = await showDialog(
                context: context,
                builder: (_) => ReviewDialog(context: context),
              );
              Review review = result[0];
              if (review != null) addReview(review);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.purple,
          ),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text(
        '${widget.flavorName}',
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
