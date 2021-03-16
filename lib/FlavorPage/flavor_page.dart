import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:developer';
import 'review.dart';
import 'review_dialog.dart';
import 'flavor_info.dart';

/// The [FlavorPage] widget describes the screen representing an ice cream flavor, all of its reviews, 
/// and a floating action button. The floating action button triggers a fab which allows the user to
/// add a review if they haven't done so yet, or edit the review they've already added.
/// 
/// Specifically, [FlavorPage] combines the [FlavorInfo] + [ReviewDialog] widgets.
/// See example_flavor_page, an example of how to combine [FlavorPage] with the rest of an application.

int buildNumber = 0; // Used for testing. TODO: remove.
typedef Callback =  Function(int);

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
  bool hasAddedReview = false; // TODO: update based on SQL query

  @override initState() {
    reviews = widget.passedReviews;
    super.initState();
  }
  
  void addReview(review) {
    hasAddedReview = true;
    reviews.insert(0, 
      Review(
        date: review.date,
        author: review.author,
        title: review.title,
        text: review.text,
        reviewStars: review.reviewStars,
        helpfulNo: review.helpfulNo,
        helpfulYes: review.helpfulYes,
        isEditable: true
      )
    );
    setState(() {});
  }

  void createEditDialog(int index) async {
     Review review =  await showDialog(
                context: context, 
                builder: (_) => ReviewDialog(context: context, review: reviews[index])
              );
      editReview(review, index);
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
      isEditable: newReview.isEditable
    );
    setState(() {});
  }

  

  @override
  Widget build(BuildContext context) {
        buildNumber += 1;
        log("Rebuild FlavorPage: $buildNumber times");
        return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('CS411 final project')
          ,), 
        body: FlavorInfo(
          flavor: widget.flavorName, 
          brand: widget.brand, 
          flavorImageUrl: widget.pngFile, 
          description: widget.description,
          passedReviews: reviews.map((review) => Review(
            author: review.author,
            title: review.title,
            date: review.date,
            reviewStars: review.reviewStars,
            text: review.text,
            helpfulYes: review.helpfulYes,
            helpfulNo: review.helpfulNo,
            isEditable: review.isEditable,
            )).toList(),
            avgRating: 1.5,
            createEditDialog: createEditDialog 
        ),

         floatingActionButton: Visibility(
           visible: !hasAddedReview,
           child: Builder(builder: (context) => 
            FloatingActionButton(onPressed: () async  {
              Review review = await showDialog(
                context: context, 
                builder: (_) => ReviewDialog(context: context)
              );
              if (review != null) addReview(review);
            }, 
            child: Icon(Icons.add),
            backgroundColor: Colors.purple,
            ),
          )
        )
      );
    }
}