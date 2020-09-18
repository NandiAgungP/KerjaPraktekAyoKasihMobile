import 'dart:convert';

import 'package:Ayo_kasih/constant/constantFile.dart';
import 'package:Ayo_kasih/constant/loading.dart';
import 'package:Ayo_kasih/utils/CustomBorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:Ayo_kasih/utils/CustomUtils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'ProductDetailsPage.dart';

class SeeAllProductPage extends StatefulWidget {
  @override
  _SeeAllProductPageState createState() => _SeeAllProductPageState();
}

class _SeeAllProductPageState extends State<SeeAllProductPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List items = new List();
  List filterItems = new List();
  bool isLoading = false;
  int userId = 0;
  String search = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllItem();
    getUserId();
  }

  // get user id from shared pref
  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getInt("id_users");
  }

  // hit api get all item
  getAllItem() async {
    this.setState(() {
      isLoading = true;
    });
    final response = await http.post(BaseUrl().getAllItem, body: {});
    final data = jsonDecode(response.body);
    this.setState(() {
      items = data;
      filterItems = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          onSaved: (e) => search = e,
          onChanged: (value){
            if(value == ""){
              this.setState(() {
                filterItems = items;
              });
            }else{

              dynamic list = items.where((item) => item["name_item"].toString().toLowerCase().contains(value.toLowerCase())).toList();
              this.setState(() {
                filterItems = list;
              });
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            border: CustomBorder.enabledBorder,
            suffixIcon: Icon(Icons.search),
            labelText: "Search ...",
            hasFloatingPlaceholder: true,
            focusedBorder: CustomBorder.focusBorder,
            errorBorder: CustomBorder.errorBorder,
            enabledBorder: CustomBorder.enabledBorder,
            labelStyle: CustomTextStyle.textFormFieldMedium
              .copyWith(
                fontSize:
                    MediaQuery.of(context).textScaleFactor *
                        16,
                color: Colors.black)),
        ),
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Builder(
        builder: (context) {
          return Container(
            color: Colors.grey.shade100,
            child: Stack(
              children: <Widget>[    
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.68),
                  itemBuilder: (context, position) {
                    return gridItem(context, position);
                  },
                  itemCount: filterItems.length,
                ),
                Constant.checkWidgetStatusLogin(isLoading)
              ],
            ),
            margin: EdgeInsets.only(bottom: 8, left: 4, right: 4, top: 8),
          );
        },
      ),
    );
  }
  // function render widget grid
  gridItem(BuildContext context, int position) {
    double leftMargin = 0;
    double rightMargin = 0;
    if (position != filterItems.length - 1) {
      leftMargin = 10;
    } else {
      leftMargin = 10;
      rightMargin = 10;
    }
    return Container(
      margin: EdgeInsets.only(left: leftMargin, right: rightMargin,bottom: 8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: GestureDetector(
        onTap: (){
          if(userId == filterItems[position]["user_id"]){
            Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => ProductDetailsPage(filterItems[position],true)));
          }else{
            Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => ProductDetailsPage(filterItems[position],false)));
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network("http://ayokasih.com/"+filterItems[position]['path'],fit: BoxFit.cover,),
                ),
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8))),
              ),
              flex: 75,
            ),
            Expanded(
              flex: 25,
              child: Container(
                padding: EdgeInsets.only(left: leftMargin, right: rightMargin),
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Utils.getSizedBox(height: 8),
                    Text(
                      filterItems[position]['name_item'],
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle.textFormFieldSemiBold.copyWith(
                          color: Colors.black.withOpacity(.7), fontSize: 12),
                    ),
                    Utils.getSizedBox(height: 4),
                    Text(
                      filterItems[position]['deskripsi_item'],
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle.textFormFieldSemiBold.copyWith(
                          color: Colors.black.withOpacity(.7), fontSize: 10),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
              ),
            )
          ],
        ),
      )
    );
  }

  var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1));
}
