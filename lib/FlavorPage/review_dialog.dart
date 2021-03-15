import 'package:flutter/material.dart';
import 'package:project/FlavorPage/review.dart';
import 'package:project/star_rating.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 
import './review.dart';
import 'package:intl/intl.dart'; 

/// The [ReviewDialog] widget displays a dialog to add or edit a review.
/// Widgets like [AddReviewDialog] and [EditReviewDialog] widgets should extend this class.
/// To use the international package, update pubspec.yaml, navigate to project folder, and run "flutter packages get".
/// 
/// Some code from https://www.youtube.com/watch?v=Fd5ZlOxyZJ4.

class ReviewDialog extends StatefulWidget {
    final BuildContext context;

    ReviewDialog({this.context});
    @override
     State<StatefulWidget> createState() => ReviewDialogState();
}

class ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  double rating = 3;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: Text("Your review"),
        content: Form(
          key: _formKey,
          child: Column(
            children: <Widget> [
              TextFormField(
                controller: authorController,
                validator: (value) {return value.isNotEmpty ? null : 'Invalid field';},
                decoration: InputDecoration(hintText: 'username'),
                ),
              SmoothStarRating(
                allowHalfRating: true,
                onRated: (v) {this.rating = v;},
                starCount: 5,
                rating: rating,
                size: 40.0,
                isReadOnly:false,
                color: Colors.green,
                borderColor: Colors.green,
                spacing:0.0, 
              ),
              TextFormField(
                controller: titleController,
                maxLines: null,
                validator: (value) {return value.isNotEmpty ? null : 'Invalid field';},
                decoration: InputDecoration(hintText: 'review title'),
                ),

              TextFormField(
                controller: textController,
                maxLines: null,
                validator: (value) {return value.isNotEmpty ? null : 'Invalid field';},
                decoration: InputDecoration(hintText: 'review content'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Add Review'),
              onPressed: (){ 
                if (_formKey.currentState.validate()) {
                    var currentTime = new DateTime.now();
                    var formatter = new DateFormat('yyyy-MM-dd');
                    String formattedDate = formatter.format(currentTime);
                    Review newReview = Review(
                      author: authorController.text,
                      text: textController.text,
                      title: titleController.text,
                      reviewStars: rating, // TODO: use double instead of int
                      helpfulYes: 0,
                      helpfulNo: 0,
                      date: formattedDate,
                  );
                  Navigator.pop(context, newReview);
                }
              },
            )
          ],
        );
  }
}