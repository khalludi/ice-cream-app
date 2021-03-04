import 'package:flutter/material.dart';
import 'review.dart';
import 'review_dialog.dart';
import 'flavor_info.dart';

class FlavorPage extends StatelessWidget {
  const FlavorPage({
    Key key,
    @required this.flavorName,
    @required this.brand,
    @required this.pngFile,
    @required this.reviews,
    @required this.context,
  });

  final String flavorName;
  final String brand;
  final String pngFile;
  final List<Map<String, Object>> reviews;
  final BuildContext context;

  Future<void> createDialog(BuildContext context) async {
      return await showDialog(context: context, builder: (_) => ReviewDialog(context: context));
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('CS411 final project')
          ,), 
        body: FlavorInfo(
          flavor: flavorName, 
          brand: brand, 
          flavorImageUrl: pngFile, 
          reviews: reviews.map((review) => Review(
            author: review['author'],
            title: review['title'],
            date: review['date'],
            reviewStars: review['reviewStars'],
            text: review['text'],
            helpfulYes: review['helpfulYes'],
            helpfulNo: review['helpfulNo'],
            
            )).toList(),
            avgRating: 4,
        ),

         floatingActionButton: Builder(builder: (context) => 
         FloatingActionButton(onPressed: () async  {
            await createDialog(context);
          }, 
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
          ),
         )
      );
    }
}