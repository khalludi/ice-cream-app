import 'package:flutter/material.dart';

import '../avg_rating.dart';
import '../flavor_image.dart';
import 'flavor_title.dart';
import 'review.dart';
import 'review_card.dart';

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
