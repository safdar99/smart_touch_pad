import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wifi_mouse/screens/connect_laptop_screen.dart';
import 'package:wifi_mouse/screens/touch_pad_screen.dart';

Socket socket;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/connectLaptop",
      routes: {
        "/connectLaptop": (ctx) => ConnectLaptopScreen(),
        "/touchPad": (ctx) => TouchPadScreen()
      },
    );
  }
}
