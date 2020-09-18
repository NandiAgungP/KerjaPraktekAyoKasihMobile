import 'package:Ayo_kasih/pages/MyItemPage.dart';
import 'package:Ayo_kasih/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/model/list_profile_section.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditProfilePage.dart';

class ProfilePage1 extends StatefulWidget {
  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  String username = "" , email= "",pathFoto ="",tokenItem = "0";
  List<ListProfileSection> listSection = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createListItem();
    getPref();
  }

  // get data dari shared pref
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
      pathFoto = preferences.getString("pathFoto");
      tokenItem = preferences.getString("token_item") ?? "0";
    });
  }

  // menu list menu profile
  void createListItem() {
    listSection.add(createSection("Barangku", "images/ic_shopping_cart.png",
        Colors.blue.shade800, MyItemPage()));
    listSection.add(createSection(
        "Logout", "images/ic_logout.png", Colors.red.withOpacity(0.7), null));
  }

  // create widget menu
  createSection(String title, String icon, Color color, Widget widget) {
    return ListProfileSection(title, icon, color, widget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomPadding: true,
      body: Builder(builder: (context) {
        return Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                      ),
                      top: -40,
                      left: -40,
                    ),
                    Positioned(
                      child: Container(
                        width: 300,
                        height: 260,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle),
                      ),
                      top: -40,
                      left: -40,
                    ),
                    Positioned(
                      child: Align(
                        child: Container(
                          width: 400,
                          height: 260,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle),
                        ),
                      ),
                      top: -40,
                      left: -40,
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  "Profile",
                  style: CustomTextStyle.textFormFieldBold
                      .copyWith(color: Colors.white, fontSize: 24),
                ),
                margin: EdgeInsets.only(top: 72, left: 24),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                    flex: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Card(
                              margin:
                                  EdgeInsets.only(top: 50, left: 16, right: 16),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 8, top: 8, right: 8, bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.settings),
                                          iconSize: 24,
                                          color: Colors.black,
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.black,
                                          iconSize: 24,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfilePage()));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    username,
                                    style: CustomTextStyle.textFormFieldBlack
                                        .copyWith(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    email,
                                    style: CustomTextStyle.textFormFieldMedium
                                        .copyWith(
                                            color: Colors.grey.shade700,
                                            fontSize: 14),
                                  ),
                                  Text(
                                    "Sisa token : " + (tokenItem == null ? "0" : tokenItem) ,
                                    style: CustomTextStyle.textFormFieldMedium
                                        .copyWith(
                                            color: Colors.grey.shade700,
                                            fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    height: 2,
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                  ),
                                  buildListView()
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 2),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: (pathFoto == "" ? AssetImage(
                                          "images/ic_user_profile.png") : NetworkImage("http://ayokasih.com/"+pathFoto)),
                                      fit: BoxFit.contain)),
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 75,
                  ),
                  Expanded(
                    child: Container(),
                    flex: 05,
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return createListViewItem(listSection[index]);
      },
      itemCount: listSection.length,
    );
  }

  createListViewItem(ListProfileSection listSection) {
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Colors.teal.shade200,
        onTap: () {
          if(listSection.title == "Logout"){
            dialogLogout(context);
          }else{
            if (listSection.widget != null) {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => listSection.widget));
            }
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 12),
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            children: <Widget>[
              Image(
                image: AssetImage(listSection.icon),
                width: 20,
                height: 20,
                color: Colors.grey.shade500,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                listSection.title,
                style: CustomTextStyle.textFormFieldBold
                    .copyWith(color: Colors.grey.shade500),
              ),
              Spacer(
                flex: 1,
              ),
              Icon(
                Icons.navigate_next,
                color: Colors.grey.shade500,
              )
            ],
          ),
        ),
      );
    });
  }
}
