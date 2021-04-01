import 'package:flutter/material.dart';
import 'package:ice_cream_social/HomePage/search.dart';
import 'package:ice_cream_social/login/login_screen.dart';
import 'package:ice_cream_social/login/profile.dart';
import 'package:ice_cream_social/login/authentication.dart';
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

  Widget chooseWidget() {
    if (_selectedIndex == 0) {
      return _widgetOptions[_selectedIndex];
    } else if (_selectedIndex == 1 && loginChanged == 0) {
      return _widgetOptions[1];
    } else if (_selectedIndex == 1 && loginChanged == 1) {
      return _widgetOptions[2];
    } else {
      return _widgetOptions[_selectedIndex];
    }
  }

  Widget build(BuildContext context) {
    Authentication auth = new Authentication();
    _widgetOptions = [];
    _widgetOptions.add(SearchWidget());
    _widgetOptions.add(LoginScreen(
      onLoginChanged: updateLoginChanged,
      auth: auth,
    ));
    // _widgetOptions.add(Profile(
    //   onLoginChanged: updateLoginChanged,
    //   auth: auth,
    // ));

    return MaterialApp(
      home: Scaffold(
        // appBar: _buildBar(context),
        body: _widgetOptions[_selectedIndex],
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
