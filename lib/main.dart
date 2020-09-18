import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'login.dart';
import 'masuk.dart';
import 'rumah.dart';

void main() => runApp(new MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{},
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // navigation page
  navigatePage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
      var value = preferences.getInt("value");
      if(value==1){
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => Home()));
      }else{
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => Login()));
      }
  }

  // splash screen timer
  splashMove() {
    return Timer(Duration(seconds: 4), navigatePage);
  }

  @override
  void initState() {
    super.initState();
    splashMove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          color: Colors.white,
          child: Center(
            child: Image(
              image: AssetImage("images/ic_logo.png"),
              height: 140,
              width: 140,
            ),
          )),
    );
  }
}
