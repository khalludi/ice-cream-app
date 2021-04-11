import 'package:flutter/material.dart';
import 'dart:developer';
import 'flavor_info.dart';
import 'review.dart';
import 'review_dialog.dart';

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
    @required this.brand,
    @required this.description,
    @required this.pngFile,
    @required this.passedReviews,
    @required this.context,
  });

  final String flavorName;
  final String brand;
  final String description;
  final String pngFile;
  final List<Review> passedReviews;
  final BuildContext context;

  @override
  _FlavorPageState createState() => _FlavorPageState();
}

class _FlavorPageState extends State<FlavorPage> {
  List<Review> reviews;
  bool hasAddedReview = false;

  @override
  initState() {
    reviews = widget.passedReviews;
    super.initState();
  }

  //  @override
  // initState() {
  //   // futureReviews = fetchReviews();
  //   super.initState();
  // }

  // Future<List<Review>> fetchReviews() async {
  //   // final response =
  //   //     await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));
  //   final response = await http.get(
  //       Uri.http(url, "reviews"), //TODO: pass in specific brand and productId
  //       headers: {"Accept": "application/json"});

  //   if (response.statusCode == 200) {
  //     log("got something");
  //     var data = json.decode(response.body);
  //     var rest = data['reviews'] as List;
  //     List<Review> reviews = (rest).map((i) => Review.fromJson(i)).toList();
  //     log("review 0, author: " + reviews[0].author);
  //     return reviews;
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     log("Error:(");
  //   }
  //   return null;
  // }

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
          is_editable: true),
    );
    log("length of reviews: " + reviews.length.toString());
    log("review 0: " + reviews[0].review_text);
    setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    buildNumber += 1;
    log("Rebuild FlavorPage: $buildNumber times");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.grey[300],
      appBar: _buildBar(context),
      body: FlavorInfo(
        flavor: widget.flavorName,
        brand: widget.brand,
        flavorImageUrl: widget.pngFile,
        description: widget.description,
        passedReviews: reviews
            .map(
              (review) => Review(
                author: review.author,
                title: review.title,
                date_updated: review.date_updated,
                stars: review.stars,
                review_text: review.review_text,
                helpful_yes: review.helpful_yes,
                helpful_no: review.helpful_no,
                is_editable: review.is_editable,
              ),
            )
            .toList(),
        avgRating: 1.5,
        createEditDialog: createEditDialog,
      ),
      floatingActionButton: Visibility(
        visible: !hasAddedReview,
        child: Builder(
          builder: (context) => FloatingActionButton(
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
    String flavorName = widget.flavorName;
    return new AppBar(
      centerTitle: true,
      title: Text(
        '$flavorName',
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
