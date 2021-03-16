import 'package:flutter/material.dart';
import 'dart:developer';
import 'review.dart';
import '../star_rating.dart';

/// The [ReviewCard] widget contains the author, title, date, and content of a review.
/// A separate widget, eg [FlavorPage], can construct a list of ReviewCards.
/// Written with help from https://www.youtube.com/watch?v=XIxahpXU_QE.

typedef Callback = Function(int);

class ReviewCard extends StatefulWidget {
  final Review review;
  final int index;
  final Callback createEditDialog;
  ReviewCard({
    @required this.review,
    @required this.index,
    this.createEditDialog
    });

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  final _months = const {
      '01': 'Jan',
      '02': 'Feb',
      '03': 'March',
      '04': 'April',
      '05': 'May',
      '06': 'June',
      '07': 'July',
      '08': 'Aug',
      '09': 'Sept',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec'
  };

  String getFormattedDate(date) {
    var result = new StringBuffer(_months[date.substring(5, 7)]);
    result.write(' ');
    result.write(date.substring(0, 4));
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey[600], width: 1),
      borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
              widget.review.title,
              style: TextStyle(
              fontSize: 18.0,
              color: Colors.lightBlue,
              )
              ),
              Text(
              getFormattedDate(widget.review.date),
              style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              )
              ),
            ],
          
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.review.author,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.purple,
                )
              ),
              StarRating(
                rating: widget.review.reviewStars.toDouble(),
                onRatingChanged: ((rating) => print("rating changed")),
                ),
              ]
            ),
          SizedBox(height: 6.0),
          Text(
            widget.review.text,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          Align(
            alignment: Alignment(0.8, -1.0),
            heightFactor: 0.5,
            child: Visibility(
              visible: (widget.review.isEditable != null) ? widget.review.isEditable : true,
              child: FloatingActionButton(
              onPressed: () => widget.createEditDialog(widget.index),
              child: Icon(Icons.edit),
              )
            ),
          ),
        ],
        ),
      )
    );
  }
}