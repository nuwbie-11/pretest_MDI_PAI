import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:mdi_app/Components/Button/myButton.dart';
import 'package:mdi_app/Components/MyTextField/mytextfield.dart';
import 'package:mdi_app/Pages/Auth/auth.dart';
import 'package:mdi_app/Pages/Details/userDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePages extends StatefulWidget {
  HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final queryController = TextEditingController();
  final countController = TextEditingController();
  int _counter = 0;
  List<dynamic> users = [];
  Map<String, dynamic> activeUser = {};

  fetchUsers() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)["users"];
      setState(() {
        users = jsonData;
      });
    }
  }

  fetchActiveProfile() async {
    final SharedPreferences prefs = await _prefs;
    final activeId = prefs.getInt('profId') ?? 0;

    final res = await http.get(
      Uri.parse('https://dummyjson.com/users/${activeId}'),
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      // print(jsonData);
      setState(() {
        activeUser = jsonData;
      });
    }
  }

  handleLogOut() async {
    final SharedPreferences prefs = await _prefs;
    final loggedOut = await prefs.remove('profId');

    if (loggedOut) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Auth()));
    }
  }

  searchUser(String query) async {
    final res = await http
        .get(Uri.parse('https://dummyjson.com/users/search?q=${query}'));

    if (res.statusCode == 200) {
      final jsonData = json.decode(res.body);
      setState(() {
        users = jsonData['users'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
    fetchActiveProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              activeUser.containsKey("firstName")
                  ? DetailComps(
                      content:
                          "${activeUser["firstName"]} ${activeUser["lastName"]}",
                      name: "Logged in as")
                  : const Text("Loading..."),
              MyTextField(
                  hint: "Cari",
                  formatted: false,
                  controller: queryController,
                  onChanged: (text) {
                    searchUser(text);
                  }),
              MyTextField(
                  hint: "Jumlah",
                  keyboardType: TextInputType.number,
                  controller: countController,
                  onChanged: (value) {
                    int temp = int.tryParse(value) ?? 0;
                    setState(() {
                      _counter = temp;
                    });
                  }),
              Expanded(
                child: users.isNotEmpty
                    ? ListView.builder(
                        itemCount: _counter == 0 ? users.length : _counter,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            onTap: () {
                              // print(users[index]["id"]);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserDetail(
                                        id: users[index]["id"].toString(),
                                      )));
                            },
                            title: Text(
                                '${users[index]["firstName"]} ${users[index]["lastName"]}'),
                          );
                        }),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
              MyButton(name: "Keluar", onPressed: handleLogOut),
            ],
          ),
        ),
      ),
    );
  }
}
