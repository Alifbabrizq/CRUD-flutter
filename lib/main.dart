import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsapp/constant/constantFile.dart';
import 'package:newsapp/mainmenu.dart';
import 'package:newsapp/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {'email': email, 'password': password});
    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String emailAPI = data['email'];
    String id_user = data['id_user'];

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, emailAPI, id_user);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  void savePref(int value, String username, String email, String id_user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("email", email);
      preferences.setString("id_user", id_user);
      preferences.commit();
    });
  }

  var value;
  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(15),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return 'Please insert email';
                    }
                  },
                  onSaved: (e) => email = e,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: showHide,
                    ),
                  ),
                ),
                MaterialButton(
                  child: Text("Login"),
                  onPressed: () {
                    check();
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    "Create New Account",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        );
        break;

      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}
