import 'dart:convert';

import 'package:Ayo_kasih/constant/constantFile.dart';
import 'package:Ayo_kasih/constant/loading.dart';
import 'package:Ayo_kasih/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Ayo_kasih/utils/CustomTextStyle.dart';
import 'package:Ayo_kasih/utils/CustomUtils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TerimaBarang extends StatefulWidget {
  @override
  _TerimaBarangState createState() => _TerimaBarangState();
}

class _TerimaBarangState extends State<TerimaBarang> {
  bool isLoading = false;
  List trans = new List();

  @override
  void initState() {
    super.initState();
    getAllItem();
  }

  // hit api kasih barang
  kasihBarang(position) async {
    this.setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id_users = preferences.getInt("id_users");
      final response = await http.post(
          BaseUrl().transaksiTerima +
              trans[position]['id_penerima'].toString() +
              "/" +
              trans[position]['id_pemberi'].toString() +
              "/" +
              trans[position]['id_item'].toString(),
          body: {});
      final data = jsonDecode(response.body);
      if (data['alert']['message']
          .toString()
          .toUpperCase()
          .contains("SUCCESSFUL")) {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(
            context,
            "Informasi",
            "Barang " +
                trans[position]['name_item'] +
                " sudah diberikan kepada " +
                trans[position]['name_user']);
        getAllItem();
      } else {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Error", "Tidak dapat memberi barang");
      }
    } catch (e) {
      print(e);
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // hit api kirim barang
  kirimBarang(position) async {
    this.setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id_users = preferences.getInt("id_users");
      final response = await http.post(
          BaseUrl().transaksiKirim +
              trans[position]['id_penerima'].toString() +
              "/" +
              trans[position]['id_pemberi'].toString() +
              "/" +
              trans[position]['id_item'].toString(),
          body: {});
      final data = jsonDecode(response.body);
      if (data['alert']['message']
          .toString()
          .toUpperCase()
          .contains("SUCCESSFUL")) {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(
            context,
            "Informasi",
            "Barang " +
                trans[position]['name_item'] +
                " sudah dikirim kepada " +
                trans[position]['name_user']);
        getAllItem();
      } else {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Error", "Tidak dapat mengirim barang");
      }
    } catch (e) {
      print(e);
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // hit api hapus transaksi
  hapusTransaksi(position) async {
    this.setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
          BaseUrl().hapusPenerima + trans[position]['id_transaksi'].toString(),
          body: {});
      final data = jsonDecode(response.body);
      if (data['message'].toString().toUpperCase().contains("SUCCESSFUL")) {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Informasi", "Transaksi berhasil dihapus");
        getAllItem();
      } else {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Error", "Tidak dapat menghapus transaksi");
      }
    } catch (e) {
      print(e);
      showAlertDialog(context, "Error", "Tidak dapat menghapus transaksi");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // hit api barang sudah sampai
  barangDiterima(position) async {
    this.setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id_users = preferences.getInt("id_users");
      final response = await http.post(
          BaseUrl().barangSampai +
              trans[position]['id_penerima'].toString() +
              "/" +
              trans[position]['id_pemberi'].toString() +
              "/" +
              trans[position]['id_item'].toString(),
          body: {});
      final data = jsonDecode(response.body);
      if (data['alert']['message']
          .toString()
          .toUpperCase()
          .contains("SUCCESSFUL")) {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(
            context,
            "Informasi",
            "Barang " +
                trans[position]['name_item'] +
                " sudah diterima oleh " +
                trans[position]['name_user']);
        getAllItem();
      } else {
        this.setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Error", "Tidak dapat memberi barang");
      }
    } catch (e) {
      print(e);
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // konfirmasi action
  dialogConfirm(BuildContext context, position, status) {
    //? set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        if (status == "2") kirimBarang(position);
        if (status == "1") kasihBarang(position);
        if (status == "3") barangDiterima(position);
        if (status == "5") hapusTransaksi(position);
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
      content: Text((status == "2"
          ? "Apakah anda yakin ingin mengirim barang ini ?"
          : (status == "3"
              ? "Apakah barang sudah sampai ?"
              : (status == "5"
                  ? "Apakah yakin menghapus transaksi ini ?"
                  : "Apakah anda yakin ingin mengambil barang ini ?")))),
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

  // hit api get transaksi
  getAllItem() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id_users = preferences.getInt("id_users");
    final response =
        await http.post(BaseUrl().listTerima + id_users.toString(), body: {});
    final data = jsonDecode(response.body);
    this.setState(() {
      trans = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Builder(
        builder: (context) {
          return Container(
            color: Colors.grey.shade100,
            child: Stack(
              children: <Widget>[
                (trans.length == 0
                    ? Center(
                        child: Text("No data found"),
                      )
                    : ListView.builder(
                        itemBuilder: (context, position) {
                          return gridItem(context, position);
                        },
                        itemCount: trans.length,
                      )),
                Constant.checkWidgetStatusLogin(isLoading),
              ],
            ),
            margin: EdgeInsets.only(bottom: 8, left: 4, right: 4, top: 8),
          );
        },
      ),
    );
  }

  // function render widget grid
  gridItem(BuildContext context, int position) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
        width: double.infinity,
        padding: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: GestureDetector(
          onTap: () {},
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "http://ayokasih.com/" + trans[position]['path'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Utils.getSizedBox(height: 8),
                      Text(
                        "Nama Barang : ",
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.textFormFieldRegular.copyWith(
                            color: Colors.black.withOpacity(.7), fontSize: 12),
                      ),
                      Utils.getSizedBox(height: 4),
                      Text(
                        trans[position]['name_item'],
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.textFormFieldBold.copyWith(
                            color: Colors.black.withOpacity(.7), fontSize: 12),
                      ),
                      Utils.getSizedBox(height: 4),
                      Text(
                        "Penerima : ",
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.textFormFieldRegular.copyWith(
                            color: Colors.black.withOpacity(.7), fontSize: 12),
                      ),
                      Utils.getSizedBox(height: 4),
                      Text(
                        trans[position]['name_user'],
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.textFormFieldBold.copyWith(
                            color: Colors.black.withOpacity(.7), fontSize: 12),
                      ),
                      Utils.getSizedBox(height: 4),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                ),
              ),
              Expanded(
                child: (trans[position]['status_transaksi'] != "1"
                    ? (trans[position]['status_transaksi'] == "2"
                        ? Container(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {},
                              child: Text(
                                "Menunggu",
                                style: CustomTextStyle.textFormFieldRegular
                                    .copyWith(
                                        color: Colors.white, fontSize: 14),
                              ),
                              color: Colors.green,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                            ),
                          )
                        : (trans[position]['status_transaksi'] == "5"
                            ? Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    dialogConfirm(context, position,
                                        trans[position]['status_transaksi']);
                                  },
                                  child: Text(
                                    "Hapus",
                                    style: CustomTextStyle.textFormFieldRegular
                                        .copyWith(
                                            color: Colors.white, fontSize: 14),
                                  ),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                              )
                            : (trans[position]['status_transaksi'] == "3"
                                ? Container(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () {
                                        dialogConfirm(
                                            context,
                                            position,
                                            trans[position]
                                                ['status_transaksi']);
                                      },
                                      child: Text(
                                        "Sampai",
                                        style: CustomTextStyle
                                            .textFormFieldRegular
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 14),
                                      ),
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                      ),
                                    ),
                                  )
                                : (trans[position]['status_transaksi'] == "4"
                                    ? Container(
                                        width: double.infinity,
                                        child: RaisedButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Done",
                                            style: CustomTextStyle
                                                .textFormFieldRegular
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                          ),
                                          color: Colors.green,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(4),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()))))
                    : Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text(
                            "Menunggu",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          color: Colors.red,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                        ),
                      )),
              )
            ],
          ),
        ));
  }
}
