import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'FilterProducts.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget();

  Future navigateToFilter(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FilterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildBar(context),
        body: Center(
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
        )
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text('ICE CREAM SOCIAL',
          style: TextStyle(fontFamily: 'Nexa', fontSize: 30, fontWeight: FontWeight.w700)),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.purple, Colors.blue])),
      ),
      //backgroundColor: Color(0x9C4FF2),
    );
  }
}
