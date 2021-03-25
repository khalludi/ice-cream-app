import 'package:flutter/material.dart';

import '../OldFlavorMain/avg_rating.dart';
import '../OldFlavorMain/flavor_image.dart';
import 'flavor_title.dart';
import 'review.dart';
import 'review_card.dart';

/// The [FlavorInfo] widget consists of the specific ice cream flavor's name, brand, image,
/// average rating, and reviews. These items are laid out as a column and the 
/// user can scroll to see all of them.
///
/// [FlavorInfo] does NOT include the floating action button and associated dialog.

class FlavorInfo extends StatelessWidget {
  final String flavor;
  final String brand;
  final String flavorImageUrl;
  final List<Review> reviews;
  final int avgRating;

  FlavorInfo({
    @required this.flavor,
    @required this.brand,
    @required this.flavorImageUrl,
    @required this.reviews,
    @required this.avgRating
  });

  /* 
   * Should return a Column. 
   * This widget is used as the body of a Scaffold widget.
   */
  @override
  Widget build(BuildContext context) {
        return ListView(children: 
        [ 
          FlavorTitle(flavor, brand),
          FlavorImage(flavorImageUrl),
          AvgRating(avgRating: avgRating,),
         // We use the spread operator (...) to extract the elements from a list,
         // because children requires a list, and not extracting would result in List(FlavorTitle, FlavorImage, List).
        ...reviews.map((review) => ReviewCard(review: review)).toList(),
       ]);
  }
}
