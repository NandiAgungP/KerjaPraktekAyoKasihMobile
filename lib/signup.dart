import 'dart:convert';
import 'dart:io';

import 'package:Ayo_kasih/constant/loading.dart';
import 'package:Ayo_kasih/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/utils/CustomBorder.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:Ayo_kasih/utils/CustomUtils.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'constant/constantFile.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _key = new GlobalKey<FormState>();
  String namaPengguna, mobileNumber, email, password, alamatUser, username;
  File file;
  bool isLoading = false;
  final picker = ImagePicker();

  // validation form
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      if (file == null) {
        showAlertDialog(context, "Error", "Silahkan pilih gambar");
      } else {
        register();
      }
    }
  }

  // file picker
  chooseImage() async {
    PickedFile _file = await picker
        .getImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      this.setState(() {
        file = File(value.path);
      });
      return value;
    });
  }

  // hit api register
  register() async {
    this.setState(() {
      isLoading = true;
    });
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(BaseUrl().register +
              "?" +
              "username=" +
              username +
              "&" +
              "alamat_user=" +
              alamatUser +
              "&" +
              "telepon_user=" +
              mobileNumber +
              "&" +
              "password=" +
              password +
              "&" +
              "roles_id=" +
              "1" +
              "&" +
              "email=" +
              email +
              "&" +
              "name_user=" +
              namaPengguna));
      request.files.add(await http.MultipartFile.fromBytes(
          'image', file.readAsBytesSync(),
          filename: file.path.split("/").last));
      var res = request.send().then((value) async {
        final respStr = await value.stream.bytesToString();
        print(respStr);
        if (respStr.toUpperCase().contains("SUCCESSFUL")) {
          showAlertDialog(
              context, "Notif", "Sukses registrasi, silahkan login");
        } else {
          var array = respStr.split(",");
          var text = "";
          for (var i = 0; i < array.length; i++) {
            var tempI = i + 1;
            var removeSiku = array[i].replaceAll("[", "");
            var removeSikuTutup = removeSiku.replaceAll("]", "");
            var removeKutip = removeSikuTutup.replaceAll("\"", "");
            if (tempI == array.length) {
              text += "- " + removeKutip;
            } else {
              text += "- " + removeKutip + "\n";
            }
          }
          print(text);
          showAlertDialog(context, "Notif", text);
        }
        this.setState(() {
          isLoading = false;
        });
        return value;
      });
    } catch (e) {
      print(e);
      this.setState(() {
        isLoading = false;
      });
      showAlertDialog(context, "Notif", "Gagal Registerasi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 60, bottom: 40),
                          child: Image(
                              image: AssetImage("images/ic_logo.png"),
                              // height: 140,
                              alignment: Alignment.center,
                              width: 200),
                        ),
                        Container(
                          margin: EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert Nama";
                                    }
                                  },
                                  onSaved: (e) => namaPengguna = e,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 16, 16, 12),
                                      border: CustomBorder.enabledBorder,
                                      labelText: "Nama",
                                      hasFloatingPlaceholder: true,
                                      focusedBorder: CustomBorder.focusBorder,
                                      errorBorder: CustomBorder.errorBorder,
                                      enabledBorder: CustomBorder.enabledBorder,
                                      labelStyle: CustomTextStyle
                                          .textFormFieldRegular
                                          .copyWith(
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  16,
                                              color: Colors.black)),
                                  keyboardType: TextInputType.text),
                              Container(
                                height: 10,
                              ),
                              TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert Username";
                                    }
                                  },
                                  onSaved: (e) => username = e,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 16, 16, 12),
                                      border: CustomBorder.enabledBorder,
                                      labelText: "Username",
                                      hasFloatingPlaceholder: true,
                                      focusedBorder: CustomBorder.focusBorder,
                                      errorBorder: CustomBorder.errorBorder,
                                      enabledBorder: CustomBorder.enabledBorder,
                                      labelStyle: CustomTextStyle
                                          .textFormFieldRegular
                                          .copyWith(
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  16,
                                              color: Colors.black)),
                                  keyboardType: TextInputType.text),
                              Container(
                                height: 10,
                              ),
                              TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert Alamat";
                                    }
                                  },
                                  onSaved: (e) => alamatUser = e,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 16, 16, 12),
                                      border: CustomBorder.enabledBorder,
                                      labelText: "Alamat",
                                      hasFloatingPlaceholder: true,
                                      focusedBorder: CustomBorder.focusBorder,
                                      errorBorder: CustomBorder.errorBorder,
                                      enabledBorder: CustomBorder.enabledBorder,
                                      labelStyle: CustomTextStyle
                                          .textFormFieldRegular
                                          .copyWith(
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  16,
                                              color: Colors.black)),
                                  keyboardType: TextInputType.text),
                              Container(
                                height: 10,
                              ),
                              TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert Mobile Number";
                                    }
                                  },
                                  onSaved: (e) => mobileNumber = e,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 16, 16, 12),
                                      border: CustomBorder.enabledBorder,
                                      labelText: "Mobile Number",
                                      hasFloatingPlaceholder: true,
                                      focusedBorder: CustomBorder.focusBorder,
                                      errorBorder: CustomBorder.errorBorder,
                                      enabledBorder: CustomBorder.enabledBorder,
                                      labelStyle: CustomTextStyle
                                          .textFormFieldRegular
                                          .copyWith(
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  16,
                                              color: Colors.black)),
                                  keyboardType: TextInputType.number),
                              Container(
                                height: 10,
                              ),
                              TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert Email";
                                    }
                                  },
                                  onSaved: (e) => email = e,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 16, 16, 12),
                                      border: CustomBorder.enabledBorder,
                                      labelText: "Email",
                                      hasFloatingPlaceholder: true,
                                      focusedBorder: CustomBorder.focusBorder,
                                      errorBorder: CustomBorder.errorBorder,
                                      enabledBorder: CustomBorder.enabledBorder,
                                      labelStyle: CustomTextStyle
                                          .textFormFieldRegular
                                          .copyWith(
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  16,
                                              color: Colors.black)),
                                  keyboardType: TextInputType.emailAddress),
                              Container(
                                height: 10,
                              ),
                              TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please insert Password";
                                  }
                                },
                                onSaved: (e) => password = e,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 16, 16, 12),
                                    border: CustomBorder.enabledBorder,
                                    labelText: "Password",
                                    hasFloatingPlaceholder: true,
                                    focusedBorder: CustomBorder.focusBorder,
                                    errorBorder: CustomBorder.errorBorder,
                                    enabledBorder: CustomBorder.enabledBorder,
                                    labelStyle: CustomTextStyle
                                        .textFormFieldRegular
                                        .copyWith(
                                            fontSize: MediaQuery.of(context)
                                                    .textScaleFactor *
                                                16,
                                            color: Colors.black)),
                                obscureText: true,
                              ),
                              Container(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    chooseImage();
                                  },
                                  child: Text(
                                    "Pilih Foto",
                                    style: CustomTextStyle.textFormFieldRegular
                                        .copyWith(
                                            color: Colors.white, fontSize: 14),
                                  ),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                ),
                              ),
                              Container(
                                height: 10,
                              ),
                              Container(
                                child: (file == null
                                    ? Center(
                                        child: Text(
                                            "Tidak ada File yang diupload"),
                                      )
                                    : Container(
                                        margin:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            file,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                          ),
                                        ),
                                      )),
                              ),
                              Container(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    check();
                                  },
                                  child: Text(
                                    "SIGNUP",
                                    style: CustomTextStyle.textFormFieldRegular
                                        .copyWith(
                                            color: Colors.white, fontSize: 14),
                                  ),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            (isLoading
                ? Constant.checkWidgetStatusLogin(isLoading)
                : Container()),
          ],
        )));
  }
}
