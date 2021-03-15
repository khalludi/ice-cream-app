import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:developer';

import '../avg_rating.dart';
import '../flavor_image.dart';
import 'flavor_title.dart';
import 'review.dart';
import 'review_card.dart';

/// The [FlavorInfo] widget consists of the specific ice cream flavor's name, brand, image,
/// average rating, and reviews. These items are laid out as a column and the 
/// user can scroll to see all of them.
///
/// [FlavorInfo] does NOT include the floating action button and associated dialog

int buildNumber = 0;

class FlavorInfo extends StatefulWidget {
  final String flavor;
  final String brand;
  final String flavorImageUrl;
  final List<Review> passedReviews;
  final double avgRating;

  FlavorInfo({
    @required this.flavor,
    @required this.brand,
    @required this.flavorImageUrl,
    @required this.passedReviews,
    @required this.avgRating,
  });

  @override
  _FlavorInfoState createState() => _FlavorInfoState();
}

class _FlavorInfoState extends State<FlavorInfo> {
  List<Review> reviews;

  @override initState() {
    reviews = widget.passedReviews;
    log("reviews length: " + reviews.length.toString());
    super.initState();
  }

  @override void didUpdateWidget(covariant FlavorInfo oldWidget) {
    log("reviews length: " + reviews.length.toString());
    reviews = widget.passedReviews;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    buildNumber += 1;
    log("Rebuild FlavorInfo: $buildNumber times");
    // ListView builder only creates items when the user reaches them
      return ListView.builder(
        itemCount: reviews.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: <Widget>[
                FlavorTitle(widget.flavor, widget.brand),
                FlavorImage(widget.flavorImageUrl),
                  Center(child: 
                    SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {},
                      starCount: 5,
                      rating: widget.avgRating,
                      size: 40.0,
                      isReadOnly:true,
                      color: Colors.green,
                      borderColor: Colors.green,
                      spacing:0.0, 
                      ),
                    ),
                  ],
            );
          }
          return ReviewCard(review: reviews[index-1]);
        }
    );
  }
}
