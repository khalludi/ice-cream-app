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

  void addReview(review) {
    hasAddedReview = true;
    reviews.insert(
        0,
        Review(
            date: review.date,
            author: review.author,
            title: review.title,
            text: review.text,
            reviewStars: review.reviewStars,
            helpfulNo: review.helpfulNo,
            helpfulYes: review.helpfulYes,
            isEditable: true));
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
      date: newReview.date,
      author: newReview.author,
      title: newReview.title,
      text: newReview.text,
      reviewStars: newReview.reviewStars,
      helpfulNo: newReview.helpfulNo,
      helpfulYes: newReview.helpfulYes,
      isEditable: newReview.isEditable,
    );
    setState(() {});
  }

  void searchReviews(String query) {
    // This line should be replaced with a SQL query for all the reviews
    // containing review_text %LIKE% query.
    reviews = [reviews[0]];
    setState(() {});
  }

  void undoSearchReviews() {
    reviews = widget.passedReviews;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    buildNumber += 1;
    log("Rebuild FlavorPage: $buildNumber times");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('CS411 final project'),
      ),
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
                date: review.date,
                reviewStars: review.reviewStars,
                text: review.text,
                helpfulYes: review.helpfulYes,
                helpfulNo: review.helpfulNo,
                isEditable: review.isEditable,
              ),
            )
            .toList(),
        avgRating: 1.5,
        createEditDialog: createEditDialog,
        searchReviews: searchReviews,
        undoSearchReviews: undoSearchReviews,
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
}
