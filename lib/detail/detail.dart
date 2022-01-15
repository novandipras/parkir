import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sql_lite/handler.dart';
import 'package:flutter_sql_lite/loading.dart';
import 'package:flutter_sql_lite/src/parkir_model.dart';
import 'package:flutter_sql_lite/update/edit.dart';

import 'card_detail.dart';

class DetailApp extends StatefulWidget {
  DetailApp({this.id});

  final int id;

  @override
  _DetailAppState createState() => _DetailAppState();
}

class _DetailAppState extends State<DetailApp> {
  DatabaseHandler handler;
  bool editing = false;
  Future<Parkir> FutureReadParkir;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          FutureReadParkir = handler.readParkir(widget.id);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(editing == false ? Icons.edit : Icons.clear),
                onPressed: () {
                  setState(() {
                    editing = !editing;
                  });
                })
          ],
          brightness: Brightness.light,
          backgroundColor: Colors.grey,
          leading: GestureDetector(onTap: () => Navigator.pushReplacementNamed(context, '/home'), child: Icon(Icons.keyboard_backspace, color: Colors.white, size: 24)),
          title: Text('Detail', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          centerTitle: true),
      backgroundColor: Colors.white,
      body: FutureBuilder<Parkir>(
          future: FutureReadParkir,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Loading(
                width: double.infinity,
                height: 70,
                radius: 12,
                hpadding: 21,
                wpadding: 21,
              );
            } else {
              return Container(
                padding: EdgeInsets.all(23),
                child: (editing == true) ? Edit(parkir: snapshot.data, handler: handler) : CardDetail(parkir: snapshot.data),
              );
            }
          }),
    );
  }
}
