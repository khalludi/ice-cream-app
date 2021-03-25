import 'package:flutter/material.dart';
import '../OldFlavorMain/star_rating.dart';

/// The [ReviewDialog] widget displays a dialog to add or edit a review.
/// Widgets like [AddReviewDialog] and [EditReviewDialog] widgets should extend this class.

class ReviewDialog extends StatefulWidget {
    final BuildContext context;

    ReviewDialog({this.context});
    @override
     State<StatefulWidget> createState() => ReviewDialogState();
}

class ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController customController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: Text("Your review"),
        content: Column(
          children: <Widget> [
            StarRating(color: Colors.pink,rating: 5,),
            TextField(
              controller: customController,
              maxLines: null,
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Add Review'),
            onPressed: (){},
          )
        ],
      );
  }

}


