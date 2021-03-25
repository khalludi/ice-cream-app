import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'HomePage/filter.dart';
import 'HomePage/placeholder_widget.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new HomePage());
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Lato');

  /**Bottom navigation drawer.**/
  static final List<Widget> _widgetOptions = <Widget>[
    PlaceholderWidget(
      Colors.pink
    ),
    PlaceholderWidget(
      Colors.purpleAccent
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: _buildBar(context),
        body: _widgetOptions[_selectedIndex],
        // body: Center(
        //   child: new Row(
        //     mainAxisSize: MainAxisSize.min,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       /**Allow users to search for products.**/
        //       Flexible(
        //           child: SearchBar()
        //       ),
        //       /**Allow users to filter products.**/
        //       Container(
        //         child: IconButton(icon: Icon(Icons.filter_list), onPressed: (){
        //           navigateToFilter(context);
        //         }),
        //       ),
        //     ],
        //   ),
        // ),
        /**Bottom navigation drawer.**/
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  /**Navigate to Filter Page.**/
  Future navigateToFilter(context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text('ICE CREAM SOCIAL', style:TextStyle(fontFamily: 'Lato', fontSize: 30)),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.purple,
                  Colors.blue
                ])
        ),
      ),
      //backgroundColor: Color(0x9C4FF2),
    );
  }
}