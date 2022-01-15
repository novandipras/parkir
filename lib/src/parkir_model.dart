class Parkir {
  Parkir({this.id, this.nomorPolisi, this.jamMasuk, this.jamKeluar, this.totalBayar});

  Parkir.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'] == null ? null : parsedJson['id'] as int,
        nomorPolisi = parsedJson['nomorPolisi'] == null ? null : parsedJson['nomorPolisi'] as String,
        jamMasuk = parsedJson['jamMasuk'] == null ? null : parsedJson['jamMasuk'] as String,
        jamKeluar = parsedJson['jamKeluar'] == null ? null : parsedJson['jamKeluar'] as String,
        totalBayar = parsedJson['totalBayar'] == null ? null : parsedJson['totalBayar'] as double;

  int id;
  String nomorPolisi;
  String jamMasuk, jamKeluar;
  double totalBayar;

  Map<String, Object> toMap() {
    return {'id': id, 'nomorPolisi': nomorPolisi, 'jamMasuk': jamMasuk, 'jamKeluar': jamKeluar, 'totalBayar': totalBayar};
  }
}
