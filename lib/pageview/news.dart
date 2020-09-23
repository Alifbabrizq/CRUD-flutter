import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsapp/constant/constantFile.dart';
import 'package:newsapp/constant/news_model.dart';
import 'package:newsapp/pageview/addnews.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/pageview/editnews.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final list = new List<NewsModel>();
  var loading = false;

  Future _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.detailNews);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new NewsModel(
          api['id_news'],
          api['image'],
          api['title'],
          api['content'],
          api['description'],
          api['date_news'],
          api['id_user'],
          api['username'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _delete(String id_news) async {
    final response =
        await http.post(BaseUrl.deleteNews, body: {'id_news': id_news});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      _lihatData();
    } else {
      print(pesan);
    }
  }

  dialogDelete(String id_news) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              children: [
                Text(
                  "Apakah Data ini Ingin di Hapus",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id_news);
                        },
                        child: Text("Yes"))
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddNews()));
          },
          child: Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            _lihatData();
          },
          child: loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.network(
                                BaseUrl.insertImage + x.image,
                                width: 150,
                                height: 120,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      x.title,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(x.date_news),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditNews(x, _lihatData)));
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  dialogDelete(x.id_news);
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    );
                  }),
        ));
  }
}
