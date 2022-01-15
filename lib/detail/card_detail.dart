import 'package:flutter/material.dart';
import 'package:flutter_sql_lite/handler.dart';
import 'package:flutter_sql_lite/shared_function.dart';
import 'package:flutter_sql_lite/src/parkir_model.dart';

class CardDetail extends StatelessWidget {
  CardDetail({this.parkir});

  Parkir parkir;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            BoxDetail(
              title: 'Id Parkir',
              content: '${parkir?.id}',
            ),
            BoxDetail(
              title: 'NOMOR KENDARAAN',
              content: '${parkir?.nomorPolisi}',
            ),
            BoxDetail(
              title: 'JAM MASUK',
              content: '${SharedFunction().convertTanggal(parkir?.jamMasuk)}',
            ),
            BoxDetail(
              title: 'JAM KELUAR',
              content: parkir?.jamKeluar != null? '${SharedFunction().convertTanggal(parkir?.jamMasuk)}' : 'BELUM KELUAR',
            ),
            BoxDetail(
              title: 'TOTAL BAYAR',
              content:'RP ${parkir?.totalBayar ?? 0}',
            ),
          ],
        ),
      ),
    );
  }
}

class BoxDetail extends StatelessWidget {
  BoxDetail({this.title, this.content});
  String title, content;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(14),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey, // Set border color
              width: 2.5),   // Set border width
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)), // Set rounded corner radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title"),
          Text("$content"),
        ],
      ),
    );
  }
}
