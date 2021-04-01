// import 'package:flutter/material.dart';

// import '../FlavorPage/flavor_page.dart';

// /// This class is used for testing our flavor page widget.
// /// This file should not be used by itself, but rather incorporated into
// /// the file for the main app.

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//     // add class variables here
//     String flavorName = "Cookies and Cream";
//     String brand = "Breyers";
//     String pngFile = "15_breyers.png";

//     // TODO: delete hard-coded reviews (for Breyers Cookies&Cream) and import using SQL queries.
//     final _reviews = const [
//       {
//         'author': 'Krisg0531',
//         'date': '2019-12-27',
//         'title': 'No oreos!!!!',
//         'reviewStars': 1,
//         'helpfulYes': 5,
//         'helpfulNo': 0,
//         'text': 'If I wanted vanilla ice cream I would have purchased it. Dug through in hopes of finding some oreos... no luck. And obviously this an on going issue from what I read of other reviews.'
//       },
//       {
//         'author': 'amh88',
//         'date': '2018-08-06',
//         'title': 'Where\'s the oreo?',
//         'reviewStars': 1,
//         'helpfulYes': 8,
//         'helpfulNo': 2,
//         'text': 'So disappointed. I probably got 2 maybe 3 tiny little pieces of oreo. Its more like crumbs not pieces.'
//       },
//       {
//         'author': 'Username286399371',
//         'title': 'Discolored ice cream',
//         'date': '2020-06-17',
//         'reviewStars': 1,
//         'helpfulYes': 0,
//         'helpfulNo': 0,
//         'text': 'I had bought the cookies an cream ice cream but upon opening it appeared to be a totally different thing. The ice cream appears to be discolored even though the container seemed intact and untampered. It does not appear to be a miss branded chocolate version of the cookies and cream but appears to be dyed with black food dye. It looks unappetizing and inedible. I have had the brand before and have never encountered this problem.'
//       },
//       {
//         'author': 'leash998',
//         'title': 'Oreo\'s Ice Cream without the Oreo\'s',
//         'date': '2020-08-21',
//         'reviewStars': 1,
//         'helpfulYes': 0,
//         'helpfulNo': 0,
//         'text': 'This was one of those late nights I was craving cookies and cream and went out to 7Eleven to pick this up. Was so disappointed! There was none, I mean ZERO cookies/Oreo\'s in this! It was straight vanilla ice cream and nothing more. I thought there might be more at the bottom? NOPE! Just more vanilla ice cream...'
//       },
//       {
//         'author': 'Mariet',
//         'title': 'OK',
//         'date': '2020-03-15',
//         'reviewStars': 2,
//         'helpfulYes': 3,
//         'helpfulNo': 0,
//         'text': 'It’s a great flavors, WHEN there are actual cookies in it, and not just a rub of Vanilla ice cream.'
//       },
//       {
//         'author': 'OreoBaby',
//         'title': 'Horrible',
//         'date': '2019-02-24',
//         'reviewStars': 1,
//         'helpfulYes': 4,
//         'helpfulNo': 1,
//         'text': 'I was getting over a break up and i got this icecream to feel better and it\'s just made me more sad then ever when I saw there was no Oreo inside I was expecting 20% more cookies, but no it\’s just plain icecream . #findingtheoreo'
//       }
//     ];

//     @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       home: FlavorPage(
//         flavorName: flavorName,
//         brand: brand,
//         pngFile: pngFile,
//         reviews: _reviews,
//         context: context,
//         )
//     );
//   }
// }
