import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ice_cream_social/backend_data.dart';
import 'package:ice_cream_social/login/profile.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';

typedef void IntCallback(int id);

class LoginScreen extends StatefulWidget {
  final IntCallback onLoginChanged;
  Authentication auth;
  final BuildContext context;
  LoginScreen({ @required this.onLoginChanged, this.auth, this.context });

  @override
  _LoginScreenState createState() => _LoginScreenState(onLoginChanged, auth);
}

class _LoginScreenState extends State<LoginScreen> {

  int toProfile = 0;
  bool _isLogin = true;
  String _userId;
  String _password;
  String _email;
  String _message = "";

  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  Authentication auth;

  IntCallback onLoginChanged;
  IntCallback onProfileChanged;
  _LoginScreenState(IntCallback onLoginChanged, Authentication auth) {
    this.onLoginChanged = onLoginChanged;
    this.auth = auth;
  }

  BackendData providerBackendData;
  String url;
  @override
  void initState() {
    providerBackendData = Provider.of<BackendData>(
      widget.context,
      listen: false
    );
    url = providerBackendData.url;
  }

  void updateProfileChanged(int newId) {
    setState(() {
      toProfile = newId;
    });
    print("Updated toProfile to $toProfile\n");
  }

  @override
  Widget build(BuildContext context) {
    return toProfile == 1 ?
      Profile(auth: auth, profileChanged: updateProfileChanged, context: context)
      : Scaffold(
      // appBar: AppBar(title: Text('Login'),),
        backgroundColor: Color(0xFFcfcfcf),
        body: Container(
            // color: Color(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/img/img1.jpg",
                ),
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                scale: 2,
                repeat: ImageRepeat.repeat,
              )
            ),
            padding: EdgeInsets.all(30),
            child: Center(
                child: Card (
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Form(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: children()
                    ),),
            )
        )
      )
    );
  }

  List<Widget> children() {
    List<Widget> ret = [
      header(),
      emailInput(),
      passwordInput(),
      mainButton(),
      secondaryButton(),
      validationMessage(),
      attribution(),
    ];

    if (!_isLogin) {
      ret.insert(1, usernameInput());
    }

    return ret;
  }

  Widget header() {
    return Padding (
        padding: EdgeInsets.only(top: 20),
        child: Text(
            _isLogin ? 'Login' : 'New User',
            style: TextStyle(
              fontFamily: 'Nexa',
              fontSize: 35,
              fontWeight: FontWeight.w700,
            )
        )
    );
  }

  Widget usernameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: TextFormField(
          controller: txtUsername,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF0F0F0),
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15),
            isDense: true,
            labelText: 'Username',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
          ),
          validator: (text) => text.isEmpty && !_isLogin ? 'Username is required' : '',
        )
    );
  }

  Widget emailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: TextFormField(
          controller: txtEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF0F0F0),
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15),
            isDense: true,
            labelText: 'Email',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
          ),
          validator: (text) => text.isEmpty ? 'Email is required' : '',
        )
    );
  }

  Widget passwordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF0F0F0),
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15),
            isDense: true,
            labelText: 'Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
          ),
          validator: (text) => text.isEmpty ? 'Password is required' : '',
        )
    );
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Container(
            height: 50,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Theme.of(context).accentColor,
              elevation: 3,
              child: Text(buttonText),
              onPressed: submit,
            )
        )
    );
  }

  Widget secondaryButton() {
    String buttonText = !_isLogin ? 'Login' : 'Sign Up';
    return FlatButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: Text(buttonText),
    );
  }

  Widget validationMessage() {
    return Text(_message,
        style: TextStyle(
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        )
    );
  }

  Widget attribution() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        "Pattern vector created by macrovector - www.freepik.com",
        style: TextStyle(
          fontFamily: "Lato",
          fontSize: 10,
        ),
      )
    );
  }

  Future submit() async {
    setState(() {
      _message = "";
    });

    try {
      if (_isLogin) {
        _userId = await auth.login(txtEmail.text, txtPassword.text);
        print('Login for user $_userId');
      } else {
        var response = await createUser(txtUsername.text, txtEmail.text);
        if (response.statusCode != 201) {
          throw Exception('Username or email already exists');
        } else {
          _userId = await auth.signUp(txtEmail.text, txtPassword.text);
          print('Sign up for user $_userId');
        }
      }
      if (_userId != null) {
        setState(() {
          toProfile = 1;
          txtEmail.text = "";
          txtUsername.text = "";
        });
        // onLoginChanged(1);
        // Navigator.replace(context, PlaceholderWidget(Colors.blueGrey));
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _message = e.message;
      });
    }
  }

  Future<http.Response> createUser(String username, String email) {
    return http.post(
      Uri.http(url, 'create-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email
      }),
    );
  }
}