import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'filter.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget();

  Future navigateToFilter(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FilterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /**Allow users to search for products.**/
          Flexible(child: SearchBar()),
          /**Allow users to filter products.**/
          Container(
            child: IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  navigateToFilter(context);
                }),
          ),
        ],
      ),
    );
  }
}
