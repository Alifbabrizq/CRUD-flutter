import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/pageview/home.dart';
import 'package:newsapp/pageview/news.dart';
import 'package:newsapp/pageview/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newsapp/pageview/category.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", email = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.lock_open),
                onPressed: () {
                  signOut();
                })
          ],
        ),
        body: TabBarView(children: <Widget>[
          Home(),
          News(),
          Categorys(),
          Profile(),
        ]),

        // Center(
        //   child: Text("Username: $username, \n Email: $email"),
        // ),
        bottomNavigationBar: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.new_releases),
                text: "News",
              ),
              Tab(
                icon: Icon(Icons.category),
                text: "Category",
              ),
              Tab(
                icon: Icon(Icons.perm_contact_calendar),
                text: "Profile",
              )
            ]),
      ),
    );
  }
}
