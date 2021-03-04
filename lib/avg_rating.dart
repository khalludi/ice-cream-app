import 'package:flutter/material.dart';

import 'star_rating.dart';

class AvgRating extends StatelessWidget {
  final int avgRating;

  AvgRating({this.avgRating});
  @override
  Widget build(BuildContext context) {
   return StarRating(
          rating: avgRating.toDouble(),
          onRatingChanged: ((rating) => print("rating changed")),
          );
  }
}