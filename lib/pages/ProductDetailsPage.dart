import 'dart:convert';

import 'package:Ayo_kasih/constant/constantFile.dart';
import 'package:Ayo_kasih/constant/loading.dart';
import 'package:Ayo_kasih/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:Ayo_kasih/utils/CustomUtils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CartPage.dart';

class ProductDetailsPage extends StatefulWidget {
  var item;
  var isMine;

  ProductDetailsPage(this.item,this.isMine);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState(item,isMine);
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with TickerProviderStateMixin<ProductDetailsPage> {

  var item;
  var isMine;
  bool isLoading = false;

  _ProductDetailsPageState(this.item,this.isMine);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // hit api ambil barang
  ambilBarang() async {
    this.setState(() {
      isLoading = true;
    });
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id_users = preferences.getInt("id_users");
      final response = await http.post(BaseUrl().requestBarang+id_users.toString()+"/"+
        item['user_id'].toString()+"/"+item['id_item'].toString(), 
      body: {});
      if (response.body.toString().toUpperCase().contains("SUCCESSFUL")) {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Informasi", "Barang sudah direquest, mohon menunggu pemberi mengkonfirmasi");
      } else {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Error", "Tidak dapat merequest barang");
      }
    }catch(e){
      print(e);
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // hit api delete barang
  deleteBarang() async {
    this.setState(() {
      isLoading = true;
    });
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id_users = preferences.getInt("id_users");
      final response = await http.post(BaseUrl().deleteItem+item['id_item'].toString()+
      "/"+item['user_id'].toString(), 
      body: {});
      if (response.body.toString().toUpperCase().contains("SUCCESSFUL")) {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Informasi", "Barang sudah didelete, mohon menunggu pemberi mengkonfirmasi");
      } else {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Error", "Tidak dapat merequest barang");
      }
    }catch(e){
      print(e);
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // hit api get item
  getOneItem() async {
    this.setState(() {
      isLoading = true;
    });
    try{
      final response = await http.post(BaseUrl().getOneItem+"/"+item['id_item'].toString(), body: {
      });
      final data = jsonDecode(response.body);
      String usernameAPI = data['user']['username'];
      if (usernameAPI != null) {
        this.setState(() {
          isLoading = false;
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString("token_item", data[0]['token_item']);
        
      } else {
        this.setState(() {
          isLoading = false;
        });
      }
    }catch(e){
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // konfirmasi action
  dialogConfirm(BuildContext context,status) {
    //? set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        if(status == 1 ){
          ambilBarang();
        }else if(status == 2){
          deleteBarang();
        }
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("BATAL"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    //? set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text((status == 1 ? "Apakah anda yakin ingin mengambil barang ini ?" : "Apakah anda yakin ingin menghapus barang ini ?")),
      actions: <Widget>[
        cancelButton,
        okButton,

      ],
    );

    //? show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var halfOfScreen = MediaQuery.of(context).size.height / 1.5;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Builder(builder: (context) {
        return Container(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Hero(
                  tag: item['id_item'],
                  child: Image.network(
                    "http://ayokasih.com/"+item['path'],
                    height: halfOfScreen,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )),
              Container(
                margin: EdgeInsets.symmetric(vertical: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      height: 28,
                      width: 32,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 14,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 4,
                            width: 4,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                          ),
                          // Container(
                          //   height: 28,
                          //   width: 32,
                          //   child: IconButton(
                          //     icon: Icon(
                          //       Icons.shopping_cart,
                          //       color: Colors.white,
                          //     ),
                          //     alignment: Alignment.center,
                          //     onPressed: () {
                          //       Navigator.of(context).push(
                          //           new MaterialPageRoute(
                          //               builder: (context) => CartPage()));
                          //     },
                          //     iconSize: 14,
                          //   ),
                          //   decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: Colors.grey.shade400),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: productDetailsSection(),
              ),
              (this.isLoading ? 
                Constant.checkWidgetStatusLogin(isLoading)
                :
                Container()
              )
            ],
          ),
        );
      }),
    );
  }

  productDetailsSection() {
    return Container(
      padding: EdgeInsets.all(8),
      height: 220,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text("Nama"),
                flex: 4,
              ),
              Expanded(
                child: Text(":"),
                flex: 1,
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      item['name_item'],
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(color: Colors.black),
                    ),
                ),
                flex: 12,
              )
              // IconButton(icon: Icon(Icons.close), onPressed: () {})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text("Deskripsi"),
                flex: 4,
              ),
              Expanded(
                child: Text(":"),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,//.horizontal
                    child: new Text(
                      item['deskripsi_item'],
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(color: Colors.black),
                    ),
                ),),
                flex: 12,
              )
              // IconButton(icon: Icon(Icons.close), onPressed: () {})
            ],
          ),
          (isMine ? 
             RaisedButton(
              onPressed: () {
                dialogConfirm(context,2);
              },
              color: Colors.red,
              padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Text(
                "Delete",
                style: CustomTextStyle.textFormFieldSemiBold
                    .copyWith(color: Colors.white),
              ),
            )
            :
            (item['status_item'] == 0 ? Container():
              RaisedButton(
                onPressed: () {
                  dialogConfirm(context,1);
                },
                color: Colors.green,
                padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24))),
                child: Text(
                  "Ambil",
                  style: CustomTextStyle.textFormFieldSemiBold
                      .copyWith(color: Colors.white),
                ),
              )
            )
          )
        ],
      ),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    );
  }

}
