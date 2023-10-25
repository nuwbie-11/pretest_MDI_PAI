import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdi_app/Components/Button/myButton.dart';
import 'package:mdi_app/Pages/HomePage/homePage.dart';

class UserDetail extends StatefulWidget {
  final String id;
  UserDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  Map<String, dynamic> details = {};

  fetchDetail() async {
    final res = await http.get(
      Uri.parse('https://dummyjson.com/users/${widget.id}'),
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      // print(jsonData);
      setState(() {
        details = jsonData;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: details.containsKey('id')
          ? Padding(
              padding: const EdgeInsets.only(
                top: 34,
                right: 24,
                left: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.network(
                          details["image"],
                          width: 64,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${details['firstName']} ${details['lastName']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                              "${details["gender"]}(${details["age"]}) | ${details["phone"]} | ${details["email"]}",
                              style: const TextStyle(
                                // fontWeight: FontWeight.w100,
                                fontSize: 9,
                              )),
                          Row(
                            children: [
                              DetailComps(
                                content:
                                    "${details["address"]["address"]}, ${details["address"]["city"]} ",
                                name: "Address",
                                style: const TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DetailComps(
                                      content: details["height"].toString(),
                                      name: "Height"),
                                  DetailComps(
                                      content: details["weight"].toString(),
                                      name: "Weight"),
                                  DetailComps(
                                      content: details["bloodGroup"].toString(),
                                      name: "Blood Type"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DetailComps(
                                      content: details["eyeColor"].toString(),
                                      name: "Eye Colour"),
                                  DetailComps(
                                      content:
                                          details["hair"]["color"].toString(),
                                      name: "Hair Colour"),
                                  DetailComps(
                                      content:
                                          details["hair"]["type"].toString(),
                                      name: "Hair Type"),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyButton(
                          name: "Kembali",
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePages()));
                          }),
                    ],
                  ),
                ],
              ),
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}

class DetailComps extends StatelessWidget {
  final String content;
  final String name;
  final TextStyle? style;

  DetailComps({
    Key? key,
    required this.content,
    required this.name,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        "$name : $content",
        style: style,
      ),
    );
  }
}
