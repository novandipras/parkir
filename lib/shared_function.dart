import 'package:intl/intl.dart';

class SharedFunction {
  String convertTanggal(String time) => DateFormat('H:mm ,dd-MMM-yyy').format(DateTime.parse(time));
}
