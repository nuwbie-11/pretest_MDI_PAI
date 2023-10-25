import 'package:flutter/material.dart';
import 'package:mdi_app/Pages/Auth/auth.dart';
import 'package:mdi_app/Pages/HomePage/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogged = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLogged = prefs.containsKey('profId');
  print(isLogged);
  runApp(MaterialApp(home: isLogged ? HomePages() : Auth()));
}
