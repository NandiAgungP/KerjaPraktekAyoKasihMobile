import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadFotoItemPage extends StatefulWidget {
  var idItem;

  UploadFotoItemPage(this.idItem);

  @override
  _UploadFotoItemPageState createState() => _UploadFotoItemPageState(idItem);
}

class _UploadFotoItemPageState extends State<UploadFotoItemPage>
    with TickerProviderStateMixin<UploadFotoItemPage> {

  var idItem;
  File file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  final picker = ImagePicker();

  _UploadFotoItemPageState(this.idItem);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // file picker
  chooseImage() async{
    PickedFile _file = await picker.getImage(source: ImageSource.gallery).then((value) {
      this.setState((){
        file = File(value.path);
      });
      return value;
    }
    ); 
  }


  @override
  Widget build(BuildContext context) {
    var halfOfScreen = MediaQuery.of(context).size.height / 1.5;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // bottom: PreferredSize(
        //     child: filterSortListOption(),
        //     preferredSize: Size(double.infinity, 44)),
        title: Text(
          "Upload Foto",
          style: CustomTextStyle.textFormFieldBold.copyWith(fontSize: 16),
        ),
        elevation: 1,
        centerTitle: true,
        // actions: <Widget>[
        //   Image(
        //     image: AssetImage("images/ic_search.png"),
        //     width: 48,
        //     height: 16,
        //   ),
        //   Image(
        //     image: AssetImage("images/ic_shopping_cart.png"),
        //     width: 48,
        //     height: 16,
        //   )
        // ],
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Builder(builder: (context) {
        return Container(
          child: Column(
            children: <Widget>[
              RaisedButton(
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
              (file == null
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
              )
            ],
          )
        );
      }),
    );
  }
}
