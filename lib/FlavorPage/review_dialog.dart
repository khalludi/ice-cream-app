import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import './review.dart';

/// The [ReviewDialog] widget displays a dialog to add or edit a review.
/// Widgets like [AddReviewDialog] and [EditReviewDialog] widgets should extend this class.
/// To use the international package, update pubspec.yaml, navigate to project folder, and run "flutter packages get".
///
/// Some code from https://www.youtube.com/watch?v=Fd5ZlOxyZJ4.

class ReviewDialog extends StatefulWidget {
  final BuildContext context;
  final Review review;

  ReviewDialog({@required this.context, this.review});
  @override
  State<StatefulWidget> createState() => ReviewDialogState();
}

class ReviewDialogState extends State<ReviewDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController textController = TextEditingController();
  double rating = 3;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    titleController.text = widget.review != null ? widget.review.title : "";
    authorController.text = widget.review != null ? widget.review.author : "";
    textController.text = widget.review != null ? widget.review.text : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Your review"),
      content: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: authorController,
              validator: (value) {
                return value.isNotEmpty ? null : 'Invalid field';
              },
              decoration: InputDecoration(hintText: 'username'),
            ),
            SmoothStarRating(
              allowHalfRating: true,
              onRated: (v) {
                this.rating = v;
              },
              starCount: 5,
              rating: widget.review != null ? widget.review.reviewStars : 5.0,
              size: 40.0,
              isReadOnly: false,
              color: Colors.green,
              borderColor: Colors.green,
              spacing: 0.0,
            ),
            TextFormField(
              controller: titleController,
              maxLines: null,
              validator: (value) {
                return value.isNotEmpty ? null : 'Invalid field';
              },
              decoration: InputDecoration(hintText: 'review title'),
            ),
            TextFormField(
              controller: textController,
              maxLines: null,
              validator: (value) {
                return value.isNotEmpty ? null : 'Invalid field';
              },
              decoration: InputDecoration(hintText: 'review content'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: (widget.review == null) ? false : true,
              child: MaterialButton(
                onPressed: () => {},
                child: MaterialButton(
                  elevation: 5.0,
                  child: Text('Delete Review'),
                  onPressed: () {
                    Navigator.pop(
                        context, [widget.review, 2]); // 2 = delete review
                  },
                ),
              ),
            ),
            MaterialButton(
              elevation: 5.0,
              child: widget.review == null
                  ? Text('Add Review')
                  : Text('Edit Review'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  var currentTime = new DateTime.now();
                  var formatter = new DateFormat('yyyy-MM-dd');
                  String formattedDate = formatter.format(currentTime);
                  Review newReview = Review(
                      author: authorController.text,
                      text: textController.text,
                      title: titleController.text,
                      reviewStars: rating,
                      helpfulYes: 0,
                      helpfulNo: 0,
                      date: formattedDate,
                      isEditable: true);
                  widget.review == null
                      ? Navigator.pop(context, [newReview, 0])
                      : Navigator.pop(context,
                          [newReview, 1]); // 0 = new review, 1 = edit review
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
