import 'package:Ayo_kasih/pages/TerimaBarang.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/pages/CartPage.dart';
import 'package:Ayo_kasih/pages/HomePage.dart';
import 'package:Ayo_kasih/pages/ProfilePage1.dart';
import 'package:Ayo_kasih/pages/SearchPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedPosition = 0;
  List<Widget> listBottomWidget = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement), title: Text("Request")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("Get Item")),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text("Add Item")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Account")),
        ],
        currentIndex: selectedPosition,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: (position) {
          setState(() {
            selectedPosition = position;
          });
        },
      ),
      body: Builder(builder: (context) {
        return listBottomWidget[selectedPosition];
      }),
    );
  }

  // add home page bottom nav bar
  void addHomePage() {
    listBottomWidget.add(HomePage());
    listBottomWidget.add(SearchPage());
    listBottomWidget.add(TerimaBarang());
    listBottomWidget.add(CartPage());
    listBottomWidget.add(ProfilePage1());
  }
}
