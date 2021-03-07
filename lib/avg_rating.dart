import 'package:flutter/material.dart';
import 'star_rating.dart';

/// The [AvgRating] widget displays the average rating for an ice cream flavor, displayed out of five stars.

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