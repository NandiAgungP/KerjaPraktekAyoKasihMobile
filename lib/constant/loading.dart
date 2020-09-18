import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// loading widget
class LoadingWidget extends StatelessWidget{

  //! [START Screen Build]
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
      ),
      child: Center(
        child: Wrap(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text('Please wait'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //! [END Screen Build]
}

class Constant{
  static checkWidgetStatusLogin(isLoading) {
    if (isLoading) {
      return LoadingWidget();
    } else {
      return Container();
    }
  }
}