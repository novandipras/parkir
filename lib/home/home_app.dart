import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sql_lite/handler.dart';
import 'package:flutter_sql_lite/list_home.dart';
import 'package:flutter_sql_lite/loading.dart';
import 'package:flutter_sql_lite/src/parkir_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: handler.retrieveParkir(),
            builder: (BuildContext context, AsyncSnapshot<List<Parkir>> snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                snapshot.data.sort((a,b) => DateTime.parse(b.jamMasuk).compareTo(DateTime.parse(a.jamMasuk)));
                return ListHome(list: snapshot.data, handler: handler);
              } else {
                return Shimmer.fromColors(
                  baseColor: Color(0xFFBDBDBD),
                  highlightColor: Color(0xFFD6D6D6),
                  child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFFBDBDBD))),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            OutlineInputBorder borderLine = OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(21));
            TextEditingController textEditingControllerNoPolisi = TextEditingController();
            TextEditingController textEditingControllerJamMasuk = TextEditingController();
            showDialog(
                context: context,
                builder: (context) {
                  textEditingControllerJamMasuk.text = DateTime.now().toString();
                  return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Text('INPUT KENDARAAN'),
                          SizedBox(
                            height: 14,
                          ),
                          TextField(
                              autofocus: true,
                              controller: textEditingControllerNoPolisi,
                              decoration: InputDecoration(
                                hintText: 'Nomor Kendaraan',
                                disabledBorder: borderLine,
                                enabledBorder: borderLine,
                                errorBorder: borderLine,
                                focusedBorder: borderLine,
                              )),
                          TextField(
                              controller: textEditingControllerJamMasuk,
                              decoration: InputDecoration(
                                hintText: 'Jam Masuk',
                                disabledBorder: borderLine,
                                enabledBorder: borderLine,
                                errorBorder: borderLine,
                                focusedBorder: borderLine,
                              )),
                          RaisedButton(
                              child: Text('CONFIRM'),
                              onPressed: () {
                                setState(() {
                                  Parkir data = Parkir(nomorPolisi: textEditingControllerNoPolisi.text.toUpperCase(), jamMasuk: textEditingControllerJamMasuk.text);
                                  if (textEditingControllerNoPolisi.text != '') handler.insertParkir(data);
                                  Navigator.pop(context);
                                });
                              }),
                        ]),
                      ));
                });
          },
          child: Icon(Icons.add),
        ));
  }
}
