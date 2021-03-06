import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:developer';
import 'review.dart';
import 'package:intl/intl.dart';

/// The [ReviewCard] widget contains the author, title, date, and content of a review.
/// A separate widget, eg [FlavorPage], can construct a list of ReviewCards.
/// Written with help from https://www.youtube.com/watch?v=XIxahpXU_QE.

typedef Callback = Function(int);

class ReviewCard extends StatefulWidget {
  final Review review;
  final int index;
  final bool allowEditing;
  final Callback createEditDialog;
  ReviewCard({
    @required this.review,
    @required this.index,
    @required this.allowEditing,
    this.createEditDialog,
  });

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  initState() {
    super.initState();
  }

  String getFormattedDate(date) {
    DateFormat formatter = new DateFormat('MMMM dd, yyyy');
    return formatter.format(date);
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
                Expanded(
                  child: Text(
                    widget.review.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                Text(
                  getFormattedDate(widget.review.date_updated),
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.review.author,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.purple,
                    ),
                  ),
                ),
                SmoothStarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  size: 20.0,
                  rating: widget.review.stars,
                  isReadOnly: true,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing: 0.0,
                ),
              ],
            ),
            SizedBox(height: 6.0),
            Text(
              widget.review.review_text,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Align(
              alignment: Alignment(0.8, -1.0),
              heightFactor: 0.5,
              child: Visibility(
                visible: (widget.review.is_editable != null)
                    ? widget.review.is_editable && widget.allowEditing
                    : true,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () => widget.createEditDialog(widget.index),
                  child: Icon(Icons.edit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
