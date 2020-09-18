import 'dart:convert';

import 'package:Ayo_kasih/constant/constantFile.dart';
import 'package:Ayo_kasih/constant/loading.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:Ayo_kasih/utils/CustomUtils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductDetailsPage.dart';

class MyItemPage extends StatefulWidget {
  @override
  _MyItemPageState createState() => _MyItemPageState();
}

class _MyItemPageState extends State<MyItemPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List items = new List();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllItem();
  }

  
  getAllItem() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id_users = preferences.getInt("id_users");
    final response = await http.post(BaseUrl().getMyItem+id_users.toString(), body: {});
    final data = jsonDecode(response.body);
    this.setState(() {
      items = data['itemByUser'];
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
        title: Text(
          "My Item",
          style: CustomTextStyle.textFormFieldBold.copyWith(fontSize: 16),
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
            child: Stack(children: <Widget>[
              Constant.checkWidgetStatusLogin(isLoading),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.68),
                itemBuilder: (context, position) {
                  return gridItem(context, position);
                },
                itemCount: items.length,
              ),
            ],),
            margin: EdgeInsets.only(bottom: 8, left: 4, right: 4, top: 8),
          );
        },
      ),
    );
  }

  gridItem(BuildContext context, int position) {
    double leftMargin = 0;
    double rightMargin = 0;
    if (position != items.length - 1) {
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
          Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => ProductDetailsPage(items[position],true)));
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network("http://ayokasih.com/"+items[position]['path'],fit: BoxFit.cover,),
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
                      items[position]['name_item'],
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle.textFormFieldSemiBold.copyWith(
                          color: Colors.black.withOpacity(.7), fontSize: 12),
                    ),
                    Utils.getSizedBox(height: 4),
                    Text(
                      items[position]['deskripsi_item'],
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

  gridBottomView(int position) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              items[position]['name_item'],
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyle.textFormFieldBold.copyWith(fontSize: 12),
              textAlign: TextAlign.start,
            ),
            alignment: Alignment.topLeft,
          ),
          Utils.getSizedBox(height: 6),
          Text(
            items[position]['deskripsi_item'],
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyle.textFormFieldBold
                .copyWith(color: Colors.indigo.shade700, fontSize: 14),
          ),
        ],
      ),
    );
  }

  var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1));
}
