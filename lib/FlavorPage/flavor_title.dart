import 'package:flutter/material.dart';

/// The [FlavorTitle] widget is a container that displays stylized text representing
/// the flavor's name and brand.

class FlavorTitle extends StatelessWidget {
  final String flavor; // Stateless Widget, so can't change text
  final String brand; // Stateless Widget, so can't change text

  FlavorTitle(this.flavor, this.brand);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column (children: [
        Text(flavor, 
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
        ),

        Text("Brand: " + brand, 
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
        ),
      ],
    ),
    );
  }
}