import 'package:Ayo_kasih/masuk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// alert dialog without action
showAlertDialog(BuildContext context, String header, String message) {
  //? set up the button
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  //? set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(header),
    content: Text(message),
    actions: <Widget>[
      okButton
    ],
  );

  //? show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// alert dialog action
showAlertDialogAction(BuildContext context, String header, String message,String routes) {
  //? set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(context,routes, (r) => false);
    },
  );

  //? set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(header),
    content: Text(message),
    actions: <Widget>[
      okButton
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

// remove auth
removeAuth() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt("value", 0);
  preferences.setString("pathFoto", "");
}

// dialog logout
dialogLogout(BuildContext context) {
  //? set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      removeAuth();
      Navigator.pushAndRemoveUntil(context,new MaterialPageRoute(
          builder: (context) => Login()), (r) => false);
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
    content: Text("Apakah anda ingin logout ?"),
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