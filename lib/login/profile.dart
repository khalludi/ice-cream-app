import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ice_cream_social/login/authentication.dart';
import 'package:ice_cream_social/login/search_users.dart';

typedef void IntCallback(int id);

class Profile extends StatefulWidget {
  final IntCallback onLoginChanged;
  Profile({ @required this.onLoginChanged });

  @override
  _ProfileState createState() => _ProfileState(onLoginChanged);
}

class _ProfileState extends State<Profile> {

  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  // final TextEditingController txtPassword = TextEditingController();

  IntCallback onLoginChanged;
  _ProfileState(IntCallback onLoginChanged) {
    this.onLoginChanged = onLoginChanged;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10)),
              header(),
              Padding(padding: EdgeInsets.only(top: 10)),
              editProfileCard(),
              Padding(padding: EdgeInsets.only(top: 14)),
              deleteButton()
            ],
          ),
        )
      )
    );
  }

  Widget header() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: //Center(
          Container(
              padding: EdgeInsets.only(left: 11, right: 10, top: 11, bottom: 8),
              child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Nexa',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  )
              )
          ),
    );
  }

  Widget editProfileCard() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Form(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                editHeader('     Username'),
                usernameInput(),
                editHeader('     Email'),
                emailInput(),
                mainButton()
              ]
          ),)
      )
    );
  }

  Widget editHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding (
          padding: EdgeInsets.only(top: 20),
          child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Nexa',
                fontSize: 25,
                fontWeight: FontWeight.w700,
              )
          )
      )
    );
  }

  Widget usernameInput() {
    txtUsername.text = "user_bobby";
    return Padding(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: TextFormField(
          controller: txtUsername,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            // filled: true,
            // fillColor: Color(0xFFF0F0F0),
            contentPadding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 15, right: 15),
            // isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
          ),
          validator: (text) => text.isEmpty ? 'Username is required' : '',
        )
    );
  }

  Widget emailInput() {
    txtEmail.text = "bobby@gmail.com";
    return Padding(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: TextFormField(
          controller: txtEmail,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,

          decoration: InputDecoration(
            // filled: true,
            // fillColor: Color(0xFFF0F0F0),
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15),
            // isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),

          ),
          validator: (text) => text.isEmpty ? 'Email is required' : '',
        )
    );
  }

  Widget mainButton() {
    String buttonText = 'SUBMIT';
    return Padding(
        padding: EdgeInsets.only(top: 20, left: 60, right: 60, bottom: 20),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 8),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.green, Colors.lightBlueAccent]),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0)
                ),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  fontFamily: 'Nexa',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget deleteButton() {
    String buttonText = 'DELETE PROFILE';
    return Padding(
        padding: EdgeInsets.only(left: 60, right: 60, bottom: 20),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.pink, Colors.deepOrangeAccent]),
              borderRadius: BorderRadius.all(
                  Radius.circular(20.0)
              ),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  fontFamily: 'Nexa',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget _buildBar(BuildContext context) {
    final Authentication auth = new Authentication();
    return new AppBar(
      centerTitle: true,
      title: Text('user_bobby',
          style: TextStyle(fontFamily: 'Nexa', fontSize: 28, fontWeight: FontWeight.w700)),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.purple, Colors.blue])),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => SearchUsers()));
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
              Icons.logout,
              color: Colors.white
          ),
          onPressed: () {
            auth.signOut();
            onLoginChanged(0);
          },
        ),
      ],
      //backgroundColor: Color(0x9C4FF2),
    );
  }
}
