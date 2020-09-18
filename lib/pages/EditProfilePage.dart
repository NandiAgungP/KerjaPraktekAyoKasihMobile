import 'dart:convert';
import 'dart:io';

import 'package:Ayo_kasih/constant/constantFile.dart';
import 'package:Ayo_kasih/constant/loading.dart';
import 'package:Ayo_kasih/utils/CustomBorder.dart';
import 'package:Ayo_kasih/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String namaPengguna,
      mobileNumber,
      email,
      password,
      alamatUser,
      username,
      pathFoto;
  final _key = new GlobalKey<FormState>();
  File file;
  bool isLoading = false;
  final picker = ImagePicker();
  TextEditingController txtNamaPengguna = new TextEditingController();
  TextEditingController txtMobileNumber = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  TextEditingController txtAlamat = new TextEditingController();
  TextEditingController txtUsername = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // validasi form
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      if (file == null) {
        showAlertDialog(context, "Error", "Silahkan pilih file");
      } else {
        updateProfile();
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

  // hit api update profile
  updateProfile() async {
    this.setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var _userId = preferences.getInt("id_users");
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(BaseUrl().updateProfil +
              _userId.toString() +
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
              "roles_id=1&" +
              "email=" +
              email +
              "&" +
              "name_user=" +
              namaPengguna));
      request.files.add(await http.MultipartFile.fromBytes(
          'image', file.readAsBytesSync(),
          filename: file.path.split("/").last));
      var res = request.send().then((value) async {
        // final respStr = await value.stream.bytesToString();
        // if(respStr.toUpperCase().contains("SUCCESSFUL")){
        //   showAlertDialog(context, "Notif", "Sukses update profile");
        // }
        http.Response.fromStream(value).then((response) async {
          if (response.body.toString().toUpperCase().contains("SUCCESSFUL")) {
            await preferences.setString("username", username);
            await preferences.setString("alamat_user", alamatUser);
            await preferences.setString("telepon_user", mobileNumber);
            await preferences.setString("name_user", namaPengguna);
            await preferences.setString("email", email);
            await preferences.setString("password", password);
            // this.setState(() {
            //   isLoading = false;
            // });
            showAlertDialog(context, "Sukses", "Update Profil Berhasil");
          } else {
            // this.setState(() {
            //   isLoading = false;
            // });
            showAlertDialog(context, "Error", "Tidak dapat update profil");
          }
        });
        this.setState(() {
          isLoading = false;
        });
        return value;
      });
    } catch (e) {
      print(e);
      showAlertDialog(context, "Error", "Tidak dapat update profil");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // ambil data dari shared pref
  getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    this.setState(() {
      namaPengguna = preferences.getString("name_user");
      mobileNumber = preferences.getString("telepon_user");
      email = preferences.getString("email");
      password = preferences.getString("password");
      alamatUser = preferences.getString("alamat_user");
      username = preferences.getString("username");
      pathFoto = preferences.getString("pathFoto");
    });
    txtNamaPengguna.text = namaPengguna;
    txtMobileNumber.text = mobileNumber;
    txtEmail.text = email;
    txtPassword.text = password;
    txtAlamat.text = alamatUser;
    txtUsername.text = username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Edit Profile",
          style: CustomTextStyle.textFormFieldBlack.copyWith(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: RaisedButton(
                          onPressed: () {
                            chooseImage();
                          },
                          child: Text(
                            "Pilih Foto",
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
                      Container(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: (file == null
                            ? Center(
                                child: Text("Tidak ada File yang diupload"),
                              )
                            : Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    file,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                  ),
                                ),
                              )),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Nama";
                            }
                          },
                          onSaved: (e) => namaPengguna = e,
                          keyboardType: TextInputType.text,
                          controller: txtNamaPengguna,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 16, 16, 12),
                              border: CustomBorder.enabledBorder,
                              labelText: "Nama",
                              hasFloatingPlaceholder: true,
                              focusedBorder: CustomBorder.focusBorder,
                              errorBorder: CustomBorder.errorBorder,
                              enabledBorder: CustomBorder.enabledBorder,
                              labelStyle: CustomTextStyle.textFormFieldMedium
                                  .copyWith(
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          16,
                                      color: Colors.black)),
                        ),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 24),
                      ),
                      Container(
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Username";
                            }
                          },
                          enabled: false,
                          controller: txtUsername,
                          onSaved: (e) => username = e,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 16, 16, 12),
                              border: CustomBorder.enabledBorder,
                              labelText: "Username",
                              hasFloatingPlaceholder: true,
                              focusedBorder: CustomBorder.focusBorder,
                              errorBorder: CustomBorder.errorBorder,
                              enabledBorder: CustomBorder.enabledBorder,
                              labelStyle: CustomTextStyle.textFormFieldMedium
                                  .copyWith(
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          16,
                                      color: Colors.black)),
                        ),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                      ),
                      Container(
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Email";
                            }
                          },
                          enabled: false,
                          onSaved: (e) => email = e,
                          controller: txtEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 16, 16, 12),
                              border: CustomBorder.enabledBorder,
                              labelText: "Email",
                              hasFloatingPlaceholder: true,
                              focusedBorder: CustomBorder.focusBorder,
                              errorBorder: CustomBorder.errorBorder,
                              enabledBorder: CustomBorder.enabledBorder,
                              labelStyle: CustomTextStyle.textFormFieldMedium
                                  .copyWith(
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          16,
                                      color: Colors.black)),
                        ),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                      ),
                      Container(
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Password";
                            }
                          },
                          onSaved: (e) => password = e,
                          controller: txtPassword,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 16, 16, 12),
                              border: CustomBorder.enabledBorder,
                              labelText: "Password",
                              hasFloatingPlaceholder: true,
                              focusedBorder: CustomBorder.focusBorder,
                              errorBorder: CustomBorder.errorBorder,
                              enabledBorder: CustomBorder.enabledBorder,
                              labelStyle: CustomTextStyle.textFormFieldMedium
                                  .copyWith(
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          16,
                                      color: Colors.black)),
                          obscureText: true,
                        ),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Alamat";
                            }
                          },
                          controller: txtAlamat,
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
                              labelStyle: CustomTextStyle.textFormFieldMedium
                                  .copyWith(
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          16,
                                      color: Colors.black)),
                        ),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                      ),
                      Container(
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Mobile Number";
                            }
                          },
                          controller: txtMobileNumber,
                          onSaved: (e) => mobileNumber = e,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 16, 16, 12),
                              border: CustomBorder.enabledBorder,
                              labelText: "Mobile number",
                              hasFloatingPlaceholder: true,
                              focusedBorder: CustomBorder.focusBorder,
                              errorBorder: CustomBorder.errorBorder,
                              enabledBorder: CustomBorder.enabledBorder,
                              labelStyle: CustomTextStyle.textFormFieldMedium
                                  .copyWith(
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          16,
                                      color: Colors.black)),
                        ),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 48, right: 48),
                        child: RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            check();
                          },
                          child: Text(
                            "Save",
                            style: CustomTextStyle.textFormFieldBlack
                                .copyWith(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            (isLoading
                ? Constant.checkWidgetStatusLogin(isLoading)
                : Container())
          ],
        ),
      ),
    );
  }

  var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(width: 1, color: Colors.grey));
}
