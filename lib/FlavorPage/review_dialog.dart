import 'package:flutter/material.dart';
import 'package:project/star_rating.dart';

/*
 * If given a pngFileName, displays the file.
 * Otherwise returns an empty widget which sizes itself to the smallest area possible.
 */
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


