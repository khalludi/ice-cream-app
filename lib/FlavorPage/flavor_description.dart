import 'package:flutter/material.dart';

/// The [FlavorDescription] widget is a container that displays stylized text representing
/// the flavor's description.

class FlavorDescription extends StatelessWidget {
  final String description; // Stateless Widget, so can't change text

  FlavorDescription(this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column (children: [
        Text(
          description, 
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.left,
        ),
      ],
    ),
    );
  }
}