import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mdi_app/Components/Button/myButton.dart';
import 'package:mdi_app/Pages/HomePage/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mdi_app/Components/MyTextField/mytextfield.dart';
import 'package:mdi_app/Constant/users.dart' as users;

import 'package:http/http.dart' as http;

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final unameController = TextEditingController();
  final passwdController = TextEditingController();
  String _Iuname = "";
  String _Ipasswd = "";
  int res = 0;
  String resMessage = "";

  handleSubmit() async {
    final SharedPreferences prefs = await _prefs;
    for (var i = 0; i < users.userList.length; i++) {
      if (users.userList[i]["userName"] == _Iuname) {
        if (users.userList[i]["password"] == _Ipasswd) {
          prefs.setInt('profId', users.userList[i]["profileId"] as int);
          setState(() {
            res = 200;
            resMessage = "Success. Redirecting";
          });
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => HomePages()));
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePages()));
          return true;
        }
        setState(() {
          res = 401;
          resMessage = "No Such User";
        });
        return false;
      }
    }
  }

  auth() async {
    final SharedPreferences prefs = await _prefs;
    http
        .post(Uri.parse('https://dummyjson.com/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"username": _Iuname, "password": _Ipasswd}))
        .then((res) => jsonDecode(res.body))
        .then((value) {
      // print(value);
      if (value.containsKey('id')) {
        prefs.setInt('profId', value['id'] as int);
        setState(() {
          res = 200;
          resMessage = "Success. Redirecting";
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePages()));
      } else {
        setState(() {
          setState(() {
            res = 401;
            resMessage = "No Such User";
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.grey.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 9,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  height: height - 180,
                  width: width - 100,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      children: [
                        const Text("MDI APP"),
                        MyTextField(
                          hint: "Username",
                          controller: unameController,
                          onChanged: (text) => {
                            setState(() {
                              _Iuname = text;
                            })
                          },
                        ),
                        MyTextField(
                          hint: "Password",
                          obscured: true,
                          controller: passwdController,
                          onChanged: (text) => {
                            setState(() {
                              _Ipasswd = text;
                            })
                          },
                        ),
                        MyButton(
                          name: "Masuk",
                          onPressed: auth,
                        ),
                        res != 0
                            ? Text("${res.toString()}:${resMessage}")
                            : const Text(""),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
