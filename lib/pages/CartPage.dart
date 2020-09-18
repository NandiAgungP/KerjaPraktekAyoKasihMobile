import 'dart:convert';

import 'package:Ayo_kasih/constant/constantFile.dart';
import 'package:Ayo_kasih/constant/loading.dart';
import 'package:Ayo_kasih/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/utils/CustomBorder.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  final _key = new GlobalKey<FormState>();
  String nameItem,deskripsiItem;
  bool isLoading = false;
  var idItem;
  File file;
  String status = '';
  String errMessage = 'Error Uploading Image';
  final picker = ImagePicker();

  // validasi form
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      if(file == null){
        showAlertDialog(context, "Error", "Silahkan pilih gambar");
      }else{
        register();

      }
    }
  }

  // file picker
  chooseImage() async{
    PickedFile _file = await picker.getImage(source: ImageSource.gallery,imageQuality: 50).then((value) {
      this.setState((){
        file = File(value.path);
      });
      return value;
    }
    ); 
  }

  // tambah barang
  register() async {
    this.setState(() {
      isLoading=true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt("id_users");
    try{
      print(BaseUrl().insertItem+"?"+
      "user_id="+userId.toString()+"&"+
      "name_item="+nameItem+"&"+
      "deskripsi_item="+deskripsiItem+"&"+
      "token_item=1&"+
      "status_item=1");
      var request = http.MultipartRequest('POST', Uri.parse(BaseUrl().insertItem+"?"+
      "user_id="+userId.toString()+"&"+
      "name_item="+nameItem+"&"+
      "deskripsi_item="+deskripsiItem+"&"+
      "token_item=1&"+
      "status_item=1"));
        request.files.add(
          await http.MultipartFile.fromBytes(
            'image',
            file.readAsBytesSync(),
            filename: file.path.split("/").last
          )
      );
      var res = request.send().then((value) async {
        final respStr = await value.stream.bytesToString();
        print(respStr);
        getToken();
        if(respStr.toUpperCase().contains("SUCCESSFULL")){
          showAlertDialog(context, "Notif", "Sukses tambah barang, silahkan cek barang yang sudah diupload melalui profil");
        } 
        this.setState(() {
          isLoading = false;
        });
        return value;
      });
    }catch(e){
      print(e);
      this.setState(() {
          isLoading = false;
      });
    }
  }

  // update token untuk profile
  getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt("id_users");
    this.setState(() {
      isLoading = true;
    });
    try{
      final response = await http.post(BaseUrl().getUser+"/"+userId.toString(), body: {
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                
                Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (e){
                                if(e.isEmpty) {
                                  return "Please insert Nama Item";
                                }
                              },
                              onSaved: (e) => nameItem = e,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                                  border: CustomBorder.enabledBorder,
                                  labelText: "Nama Item",
                                  hasFloatingPlaceholder: true,
                                  focusedBorder: CustomBorder.focusBorder,
                                  errorBorder: CustomBorder.errorBorder,
                                  enabledBorder: CustomBorder.enabledBorder,
                                  labelStyle: CustomTextStyle.textFormFieldRegular
                                      .copyWith(
                                          fontSize:
                                              MediaQuery.of(context).textScaleFactor *
                                                  16,
                                          color: Colors.black)),
                              keyboardType: TextInputType.text),
                            Container(height: 10,),
                            TextFormField(
                              validator: (e){
                                if(e.isEmpty) {
                                  return "Please insert Deskripsi";
                                }
                              },
                              onSaved: (e) => deskripsiItem = e,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                                  border: CustomBorder.enabledBorder,
                                  labelText: "Deskripsi",
                                  hasFloatingPlaceholder: true,
                                  focusedBorder: CustomBorder.focusBorder,
                                  errorBorder: CustomBorder.errorBorder,
                                  enabledBorder: CustomBorder.enabledBorder,
                                  labelStyle: CustomTextStyle.textFormFieldRegular
                                      .copyWith(
                                          fontSize:
                                              MediaQuery.of(context).textScaleFactor *
                                                  16,
                                          color: Colors.black)),
                              keyboardType: TextInputType.text),
                            Container(height: 10,),
                            Container(
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  chooseImage();
                                },
                                child: Text(
                                  "Pilih Gambar",
                                  style: CustomTextStyle.textFormFieldRegular
                                      .copyWith(color: Colors.white, fontSize: 14),
                                ),
                                color: Colors.red,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                              ),
                            ),
                            Container(height: 10,),
                            Container(
                              child: (file == null
                                  ? Center(child: Text("Tidak ada File yang diupload"),)
                                  : Container(
                                    margin: EdgeInsets.only(left: 8,right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          file,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height / 2,
                                      ),
                                    ), 
                                  )
                              ),
                            ),
                            Container(height: 10,),
                            Container(
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  check();
                                },
                                child: Text(
                                  "Tambah Item",
                                  style: CustomTextStyle.textFormFieldRegular
                                      .copyWith(color: Colors.white, fontSize: 14),
                                ),
                                color: Colors.red,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Constant.checkWidgetStatusLogin(isLoading)
              ],
            ),
          )
        ),
      )
    );
  }
}
