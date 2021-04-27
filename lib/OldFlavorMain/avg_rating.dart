import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

/// The [AvgRating] widget displays the average rating for an ice cream flavor, displayed out of five stars.

class AvgRating extends StatelessWidget {
  final double avgRating;

  AvgRating({this.avgRating});
  @override
  Widget build(BuildContext context) {
   return SmoothStarRating(
      allowHalfRating: true,
      onRated: (v) {},
      starCount: 5,
      rating: avgRating,
      size: 40.0,
      isReadOnly:true,
      color: Colors.green,
      borderColor: Colors.green,
      spacing:0.0, 
   );
  }
}