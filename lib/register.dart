import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/constant/constantFile.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _secureText = true;
  String email, password, username;
  final _key = new GlobalKey<FormState>();

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      register();
    }
  }

  register() async {
    final response = await http.post(BaseUrl.register,
        body: {'email': email, 'password': password, 'username': username});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  return 'Please insert username';
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: 'Usrname'),
            ),
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
                  icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: showHide,
                ),
              ),
            ),
            MaterialButton(
              child: Text("Register"),
              onPressed: () {
                check();
              },
            ),
          ],
        ),
      ),
    );
  }
}
