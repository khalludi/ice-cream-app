import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

/// The [Review] class describes an ice cream review.
///
/// Qualitative data
///
/// author: author of the review
/// brand: what the author titled the review
/// date_updated: date that the review was last edited. In format 'yyyy-mm-dd.'
/// title: what the author titled the review
/// review_text: content of the review.
///
/// Quantitative data
/// review_id: id of the review; the id plus the brand uniquely identify each review.
/// product_id: each review corresponds to exactly 1 product; this is the id of that product.
/// stars: how the author ranks the review against other reviews. Range: 1-5 stars, inclusive.
/// helpful_yes: how many people marked this review as helpful.
/// helpful_no: how many people marked this review as not helpful.
/// is_editable: whether the user that's currently signed in can edit this review.

class Review {
  // ignore: non_constant_identifier_names
  int review_id;
  // ignore: non_constant_identifier_names
  int product_id;
  String author;
  String brand;
  DateTime date_updated;
  String title;
  double stars;
  String review_text;
  int helpful_yes;
  int helpful_no;
  bool is_editable;

  Review({
    this.review_id,
    this.product_id,
    this.author,
    this.brand,
    this.date_updated,
    this.title,
    this.stars,
    this.review_text,
    this.helpful_yes,
    this.helpful_no,
    this.is_editable,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      review_id: json['review_id'] as int,
      product_id: json['product_id'],
      author: json['author'],
      brand: json['brand'],
      date_updated: DateFormat('yyyy-MM-dd').parse(json['date_updated']),
      // date_updated: DateTime.now(),
      title: json['title'],
      stars: json['stars'] + .0,
      review_text: json['review_text'],
      helpful_yes: json['helpful_yes'],
      helpful_no: json['helpful_no'],
      is_editable: false,
    );
  }
  Map<String, String> toJson() => {
        'product_id': product_id.toString(),
        'brand': brand,
        'author': author,
        'date_updated': DateFormat('yyyy-MM-dd').format(date_updated),
        'title': title,
        'stars': stars.toString(),
        'helpful_yes': helpful_yes.toString(),
        'helpful_no': helpful_no.toString(),
        'review_text': review_text.toString(),
      };
}
