import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../OldFlavorMain/flavor_image.dart';
import 'flavor_title.dart';
import 'review.dart';
import 'review_card.dart';
import 'flavor_description.dart';
import 'search_reviews.dart';
import 'dart:developer';

/// The [FlavorInfo] widget consists of the specific ice cream flavor's name, brand, image,
/// average rating, and reviews. These items are laid out as a column and the
/// user can scroll to see all of them.
///
/// [FlavorInfo] does NOT include the floating action button and associated dialog

int buildNumber = 0;
typedef Callback = Function(int);
typedef Callback2 = Function(String);

class FlavorInfo extends StatefulWidget {
  final int productId;
  final String flavor;
  final String brand;
  final String description;
  final String flavorImageUrl;
  final List<Review> passedReviews;
  final double avgRating;
  final Callback createEditDialog;

  FlavorInfo({
    @required this.productId,
    @required this.flavor,
    @required this.brand,
    @required this.description,
    @required this.flavorImageUrl,
    @required this.passedReviews,
    @required this.avgRating,
    @required this.createEditDialog,
  });
  @override
  _FlavorInfoState createState() => _FlavorInfoState();
}

class _FlavorInfoState extends State<FlavorInfo> {
  List<Review> reviews;
  String brandId;
  Map<String, String> brandIdMap = {
    'Breyers': 'breyers',
    'Ben & Jerry\'s': 'bj',
    'Talenti': 'talenti',
    'Haagen Daaz': 'hd',
  };

  @override
  initState() {
    reviews = widget.passedReviews;
    brandId = brandIdMap[widget.brand];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FlavorInfo oldWidget) {
    reviews = widget.passedReviews;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    buildNumber += 1;
    // ListView builder only creates items when the user reaches them
    return buildReviewList();
  }

  Widget buildReviewList() {
    return ListView.builder(
      itemCount: reviews.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: <Widget>[
              FlavorTitle(widget.flavor, widget.brand),
              FlavorImage(widget.flavorImageUrl),
              Center(
                child: SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (v) {},
                  starCount: 5,
                  rating: widget.avgRating,
                  size: 40.0,
                  isReadOnly: true,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing: 0.0,
                ),
              ),
              FlavorDescription(widget.description),
              Align(
                // launches search page
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => routeSearchReviews(context),
                ),
              ),
            ],
          );
        } else {
          return ReviewCard(
            review: reviews[index - 1],
            index: index - 1,
            allowEditing: true,
            createEditDialog: widget.createEditDialog,
          );
        }
      },
    );
  }

  void routeSearchReviews(BuildContext context) {

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => SearchReviews(
          productId: widget.productId,
          brandId: widget.brand,
          context: context,
        ),
      ),
    );
  }
}
