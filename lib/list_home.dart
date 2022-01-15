import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sql_lite/handler.dart';
import 'package:flutter_sql_lite/shared_function.dart';
import 'package:flutter_sql_lite/src/parkir_model.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class ListHome extends StatefulWidget {
  ListHome({this.list, this.handler});

  List<Parkir> list;
  DatabaseHandler handler;

  @override
  _ListHomeState createState() => _ListHomeState();
}

class _ListHomeState extends State<ListHome> {
  List<Parkir> verticalData = [];

  final int increment = 10;

  bool isLoadingVertical = false;

  @override
  void initState() {
    _loadMoreVertical();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _loadMoreVertical() async {
    int lengthPencarian = (verticalData.length + increment >= widget.list.length) ? widget.list.length : verticalData.length + increment;
    if (!mounted) return;
    setState(() {
      isLoadingVertical = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    verticalData.addAll(widget.list.getRange(verticalData.length, lengthPencarian));

    if (!mounted) return;
    setState(() {
      isLoadingVertical = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      isLoading: isLoadingVertical,
      onEndOfPage: () => _loadMoreVertical(),
      child: Scrollbar(
        child: ListView.builder(
          itemCount: verticalData.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/detail/${verticalData[index].id}');
              },
              child: Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    )),
                key: ValueKey<int>(verticalData[index].id),
                onDismissed: (DismissDirection direction) async {
                  await widget.handler.deleteParkir(verticalData[index].id);
                  verticalData.removeWhere((element) => element.id == verticalData[index].id);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Nomor Kendaraan : '),
                          Text('${verticalData[index].nomorPolisi}'),
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Text('Jam Masuk : '),
                          Text('${SharedFunction().convertTanggal(verticalData[index].jamMasuk)}'),
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Text('Jam Keluar : '),
                          Text(verticalData[index].jamKeluar != null ? '${SharedFunction().convertTanggal(verticalData[index].jamKeluar)}': 'Belum Keluar'),
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Text('Total Bayar : '),
                          Text(verticalData[index].totalBayar != null ? 'Rp ${verticalData[index].totalBayar}': '0'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
