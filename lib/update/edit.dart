import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sql_lite/handler.dart';
import 'package:flutter_sql_lite/shared_function.dart';
import 'package:flutter_sql_lite/src/parkir_model.dart';
import 'package:flutter_sql_lite/update/app_string.dart';
import 'package:intl/intl.dart';

class Edit extends StatelessWidget {
  Edit({this.handler, this.parkir});

  DatabaseHandler handler;
  Parkir parkir;
  TextEditingController controllerNomorKendaraan = TextEditingController();
  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerJamMasuk = TextEditingController();
  TextEditingController controllerJamKeluar = TextEditingController();
  TextEditingController controllerTotalBayar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controllerNomorKendaraan.text = parkir.nomorPolisi;
    controllerId.text = parkir.id.toString();
    controllerJamMasuk.text = SharedFunction().convertTanggal(parkir?.jamMasuk);
    if (parkir.jamKeluar != null)
      controllerJamKeluar.text = SharedFunction().convertTanggal(parkir?.jamKeluar);
    controllerTotalBayar.text = (parkir.totalBayar != null) ? parkir?.totalBayar.toString() : '0';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextFormField(
        readOnly: true,
        controller: controllerId,
        decoration: InputDecoration(
          icon: Icon(Icons.confirmation_number_outlined),
          hintText: 'Masukan Id ',
          labelText: 'Id Parkir',
        ),
      ),
      TextFormField(
        controller: controllerNomorKendaraan,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
          icon: Icon(Icons.timer_10),
          hintText: 'Masukan Nomor Kendaraan',
          labelText: 'Nomor Kendaraan',
        ),
        validator: (String value) {
          return value.length > 9 ? 'Melebihi Batas' : null;
        },
      ),
      TextFormField(
          controller: controllerJamMasuk,
          readOnly: true,
          onTap: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                  DateFormat("H:mm ,dd-MMM-yyy").parse(controllerJamMasuk.text)),
              initialEntryMode: TimePickerEntryMode.input,
              confirmText: "CONFIRM",
              helpText: "Jam Masuk",
            ).then((value) {
              if (value != null) {
                DateTime DateTimeSelected = DateTime(
                    DateTime.parse(parkir?.jamMasuk).year,
                    DateTime.parse(parkir?.jamMasuk).month,
                    DateTime.parse(parkir?.jamMasuk).day,
                    value.hour,
                    value.minute);
                controllerJamMasuk.text =
                    SharedFunction().convertTanggal(DateTimeSelected.toString());
                int difTime = DateFormat("H:mm ,dd-MMM-yyy")
                    .parse(controllerJamKeluar.text)
                    .difference(DateFormat("H:mm ,dd-MMM-yyy").parse(controllerJamMasuk.text))
                    .inHours;
                controllerTotalBayar.text = (difTime * AppString.TARIF).toString();
              }
            });
          },
          decoration: InputDecoration(
            icon: Icon(Icons.timer_outlined),
            hintText: 'Jam Masuk Kendaraan',
            labelText: 'Jam Masuk',
          )),
      TextFormField(
          controller: controllerJamKeluar,
          readOnly: true,
          onTap: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime((parkir?.jamKeluar != null)
                  ? DateFormat("H:mm ,dd-MMM-yyy").parse(controllerJamKeluar.text)
                  : DateTime.now()),
              initialEntryMode: TimePickerEntryMode.input,
              confirmText: "CONFIRM",
              helpText: "Jam Keluar",
            ).then((value) {
              if (value != null) {
                DateTime DateTimeSelected = DateTime(
                    (parkir?.jamKeluar != null)
                        ? DateTime.parse(parkir?.jamKeluar).year
                        : DateTime.now().year,
                    (parkir?.jamKeluar != null)
                        ? DateTime.parse(parkir?.jamKeluar).month
                        : DateTime.now().month,
                    (parkir?.jamKeluar != null)
                        ? DateTime.parse(parkir?.jamKeluar).day
                        : DateTime.now().day,
                    value.hour,
                    value.minute);
                controllerJamKeluar.text =
                    SharedFunction().convertTanggal(DateTimeSelected.toString());
                int difTime = DateFormat("H:mm ,dd-MMM-yyy")
                    .parse(controllerJamKeluar.text)
                    .difference(DateFormat("H:mm ,dd-MMM-yyy").parse(controllerJamMasuk.text))
                    .inHours;
                controllerTotalBayar.text = (difTime * 2000).toString();
              }
            });
          },
          decoration: InputDecoration(
            icon: Icon(Icons.timer_off),
            hintText: 'Jam Keluar Kendaraan',
            labelText: 'Jam Keluar',
          )),
      TextFormField(
        controller: controllerTotalBayar,
        decoration: InputDecoration(
          icon: Icon(Icons.monetization_on_outlined),
          hintText: 'Total Bayar',
          labelText: 'Rupiah',
        ),
      ),
      SizedBox(
        height: 24,
      ),
      ElevatedButton(
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text("Simpan"),
          ),
        ),
        onPressed: () {
          Parkir updateData = Parkir(
              id: int.parse(controllerId.text),
              nomorPolisi: controllerNomorKendaraan.text,
              jamMasuk: DateFormat("H:mm ,dd-MMM-yyy").parse(controllerJamMasuk.text).toString(),
              jamKeluar: DateFormat("H:mm ,dd-MMM-yyy").parse(controllerJamKeluar.text).toString(),
              totalBayar: double.parse(controllerTotalBayar.text));
          handler.updateParkir(updateData);
          Navigator.pushReplacementNamed(context, '/detail/${controllerId.text}');
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          primary: Colors.red,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      )
    ]);
  }
}
