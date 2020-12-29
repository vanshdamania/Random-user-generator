import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List usersData;
  bool isLoading = true;
  final String url = "https://randomuser.me/api/?results=50";

  Future getData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    List data = jsonDecode(response.body)['results'];

    setState(() {
      usersData = data;
      isLoading = false;
    });
  }

  List<dynamic> users = [];

  void fetchUsers() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    users = jsonDecode(response.body)['results'];

    setState(() {
      usersData = users;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Future<void> getrData() async {
    setState(() {
      fetchUsers();
    });
  }

  void initState2() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Random User'),
        ),
        body: Container(
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : RefreshIndicator(
                    child: ListView.builder(
                      itemCount: usersData == null ? 0 : usersData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(20.0),
                                child: Image(
                                  width: 70.0,
                                  height: 70.0,
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                      usersData[index]['picture']['thumbnail']),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      usersData[index]['name']['first'] +
                                          " " +
                                          usersData[index]['name']['last'],
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(5.0)),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                        ),
                                        Text(
                                          usersData[index]['phone'],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.mail,
                                        ),
                                        Text(
                                          usersData[index]['email'],
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.person),
                                        Text(
                                          usersData[index]['gender'],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onRefresh: getrData,
                  ),
          ),
        ));
  }
}