import 'dart:convert';

import 'package:Ayo_kasih/constant/constantFile.dart';
import 'package:Ayo_kasih/constant/loading.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/utils/CustomBorder.dart';
import 'package:Ayo_kasih/utils/CustomColors.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:Ayo_kasih/utils/CustomUtils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductDetailsPage.dart';
import 'SeeAllProductPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> listImage = new List();
  int selectedSliderPosition = 0;
  List articles = new List();
  List newestItem = new List();
  List sortedByAlhpabetItems = new List();
  List sortedByDateItems = new List();
  bool isLoading = false;
  int userId = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItem();
    getUserId();
  }

  // ambil user id dari shared pref
  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getInt("id_users");
  }

  // hit api get paging item
  getItem() async {
    this.setState(() {
      isLoading = true;      
    });
    final response = await http.post(BaseUrl().pagingItem, body: {});
    final data = jsonDecode(response.body);
    this.setState(() {
      articles = data['article'];
      newestItem = data['latest']['data'];
      isLoading = false;
      sortedByAlhpabetItems = data['alphaAsc']['data'];
      sortedByDateItems = data['dateAsc']['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.red,
                  height: height / 4,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: (height / 4) + 25,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: height / 5,
                          child: (articles.length == 0 ? Container():
                          PageView.builder(
                            itemBuilder: (context, position) {
                              return createSlider(articles[position]);
                            },
                            controller: PageController(viewportFraction: .9),
                            itemCount: articles.length,
                            onPageChanged: (position) {
                              /*setState(() {
                              selectedSliderPosition = position;
                            });*/
                            },
                          )
                        ),),
                      ),
                      Utils.getSizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => SeeAllProductPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16, left: 16),
                              child: Text(
                                "BARANG TERBARU",
                                style: CustomTextStyle.textFormFieldSemiBold
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  Text("SEE ALL",
                                      style: CustomTextStyle.textFormFieldSemiBold
                                          .copyWith(color: Colors.grey.shade700)),
                                  Icon(Icons.arrow_forward),
                                  Utils.getSizedBox(width: 16),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Utils.getSizedBox(height: 10),
                      /*Group By Product Listing*/
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: (newestItem.length == 0 ? Container():
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return createGroupBuyListItem(
                                  newestItem,newestItem[index], index);
                            },
                            itemCount: newestItem.length,
                          )
                        ),
                      ),

                      /*Most Big Product Listing*/
                      Utils.getSizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => SeeAllProductPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16, left: 16),
                              child: Text(
                                "BERDASARKAN HURUF",
                                style: CustomTextStyle.textFormFieldSemiBold
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  Text("SEE ALL",
                                      style: CustomTextStyle.textFormFieldSemiBold
                                          .copyWith(color: Colors.grey.shade700)),
                                  Icon(Icons.arrow_forward),
                                  Utils.getSizedBox(width: 16),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Utils.getSizedBox(height: 10),
                      /*Group By Product Listing*/
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: (newestItem.length == 0 ? Container():
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return createGroupBuyListItem(
                                  sortedByAlhpabetItems,sortedByAlhpabetItems[index], index);
                            },
                            itemCount: sortedByAlhpabetItems.length,
                          )
                        ),
                      ),
                      Utils.getSizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => SeeAllProductPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16, left: 16),
                              child: Text(
                                "BERDASARKAN TANGGAL",
                                style: CustomTextStyle.textFormFieldSemiBold
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  Text("SEE ALL",
                                      style: CustomTextStyle.textFormFieldSemiBold
                                          .copyWith(color: Colors.grey.shade700)),
                                  Icon(Icons.arrow_forward),
                                  Utils.getSizedBox(width: 16),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Utils.getSizedBox(height: 10),
                      /*Group By Product Listing*/
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: (newestItem.length == 0 ? Container():
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return createGroupBuyListItem(
                                  sortedByDateItems,sortedByDateItems[index], index);
                            },
                            itemCount: sortedByDateItems.length,
                          )
                        ),
                      ),
                      Utils.getSizedBox(height: 10),
                    ],
                  ),
                ),
                Constant.checkWidgetStatusLogin(isLoading),
              ],
            ),
          );
        },
      ),
    );
  }

  // slider article
  createSlider(items) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: ClipRRect(
          child: Image.network("http://ayokasih.com/"+items['path'],fit: BoxFit.cover,),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // render item
  createGroupBuyListItem(listItem,items, int index) {
    double leftMargin = 0;
    double rightMargin = 0;
    if (index != listItem.length - 1) {
      leftMargin = 10;
    } else {
      leftMargin = 10;
      rightMargin = 10;
    }
    return Container(
      margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: GestureDetector(
        onTap: (){
          if(userId == items["user_id"]){
            Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => ProductDetailsPage(items,true)));
          }else{
            Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => ProductDetailsPage(items,false)));
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
                  child: Image.network("http://ayokasih.com/"+items['path'],fit: BoxFit.cover,),
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
                      items['name_item'],
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle.textFormFieldSemiBold.copyWith(
                          color: Colors.black.withOpacity(.7), fontSize: 12),
                    ),
                    Utils.getSizedBox(height: 4),
                    Text(
                      items['deskripsi_item'],
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
}
