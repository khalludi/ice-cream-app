import 'package:flutter/material.dart';
import 'package:ice_cream_social/HomePage/search.dart';
import 'package:ice_cream_social/login/login_screen.dart';
import 'HomePage/filter.dart';
import 'HomePage/placeholder_widget.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(home: new HomePage());
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int loginChanged = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Lato');

  /**Bottom navigation drawer.**/
  List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateLoginChanged(int newId) {
    setState(() {
      loginChanged = newId;
    });
  }

  Widget build(BuildContext context) {
    _widgetOptions = [];
    _widgetOptions.add(SearchWidget());
    _widgetOptions.add(LoginScreen(
      onLoginChanged: updateLoginChanged,
    ));
    _widgetOptions.add(PlaceholderWidget(Colors.green));

    return MaterialApp(
      home: Scaffold(
        appBar: _buildBar(context),
        body: _selectedIndex == 0
            ? _widgetOptions[_selectedIndex]
            : _selectedIndex == 1 && loginChanged == 0
                ? _widgetOptions[1]
                : _selectedIndex == 1 && loginChanged == 1
                    ? _widgetOptions[2]
                    : _widgetOptions[_selectedIndex],
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

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Text('ICE CREAM SOCIAL',
          style: TextStyle(fontFamily: 'Lato', fontSize: 30)),
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
