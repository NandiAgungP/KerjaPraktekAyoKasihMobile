import 'dart:convert';
import 'package:Ayo_kasih/pages/HomePage.dart';
import 'package:Ayo_kasih/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Ayo_kasih/constant/constantFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/signup.dart';
import 'package:Ayo_kasih/rumah.dart';
import 'package:Ayo_kasih/utils/CustomBorder.dart';
// import 'package:Ayo_kasih/utils/CustomColors.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:Ayo_kasih/utils/CustomUtils.dart';

import 'constant/loading.dart';

// import 'package:Ayo_kasih/pages/HomePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = new GlobalKey<FormState>();
  String email, password;
  bool _secureText = true;
  bool isLoading = false;

  // show hide password
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  // validation form
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  // hit api login
  login() async {
    this.setState(() {
      isLoading = true;
    });
    try{
      final response = await http.post(BaseUrl().login+"/"+email, body: {
        "pass":password
      });
      final data = jsonDecode(response.body);
      String usernameAPI = data['user']['username'];
      if (usernameAPI != null) {
        this.setState(() {
          isLoading = false;
        });
        setState(() {
          // _loginStatus = LoginStatus.signIn;
          savePref(data);
        });
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => Home()));
      } else {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Error", "Tidak dapat login");
      }
    }catch(e){
      showAlertDialog(context, "Error", "Tidak dapat login");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // save user data to shared pref
  savePref(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt("value", 1);
      await preferences.setString("username", data['user']['username']);
      await preferences.setString("alamat_user", data['user']['alamat_user']);
      await preferences.setString("telepon_user", data['user']['telepon_user']);
      await preferences.setString("name_user", data['user']['name_user']);
      await preferences.setString("email", data['user']['email']);
      await preferences.setString("password", data['user']['password']);
      await preferences.setString("token_item", data['user']['token_item']);
      await preferences.setInt("id_users", data['user']['id_user']);
      try{
        await preferences.setString("pathFoto", data['uphoto']['path']);
      }catch(e){
        // do nothing
      }
  }

  // get pref data
  var value;
  getPref() async {
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if(value==1){
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => Home()));
      }
      this.setState(() {
      });
    }catch(e){
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Builder(builder: (context) {
        return Stack(children: <Widget>[
          Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                      image: AssetImage("images/ic_logo.png"),
                      height: 140,
                      alignment: Alignment.center,
                      width: 200),
                  flex: 40,
                ),
                Expanded(
                  child: Form(
                    key: _key,
                    child: 
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (e){
                              if(e.isEmpty) {
                                return "Please insert email";
                              }
                            },
                            onSaved: (e) => email = e,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                              border: CustomBorder.enabledBorder,
                              labelText: "Email",
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
                          Utils.getSizedBox(height: 20),
                          TextFormField(
                            obscureText: _secureText,
                            onSaved: (e) => password = e,
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                              border: CustomBorder.enabledBorder,
                              focusedBorder: CustomBorder.focusBorder,
                              errorBorder: CustomBorder.errorBorder,
                              enabledBorder: CustomBorder.enabledBorder,
                              labelStyle: CustomTextStyle.textFormFieldMedium
                                .copyWith(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            16,
                                    color: Colors.black) 
                            ),
                          ),
                          Utils.getSizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                check();
                              },
                              child: Text(
                                "LOGIN",
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
                          Utils.getSizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account?",
                                style: CustomTextStyle.textFormFieldMedium
                                    .copyWith(fontSize: 14),
                              ),
                              Utils.getSizedBox(width: 4),
                              GestureDetector(
                                child: Text(
                                  "Sign Up",
                                  style: CustomTextStyle.textFormFieldBold
                                      .copyWith(fontSize: 14, color: Colors.blue),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (context) => SignUp()));
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  flex: 60,
                )
              ],
            ),
          ),
          Constant.checkWidgetStatusLogin(isLoading)
        ],);
      }),
    );
  }
}
