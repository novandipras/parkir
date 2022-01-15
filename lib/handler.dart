import 'package:flutter_sql_lite/src/parkir_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'parkirkendaraanbermotor.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE parkir_kendaraan(id INTEGER PRIMARY KEY AUTOINCREMENT, nomorPolisi TEXT NOT NULL, jamMasuk TEXT, jamKeluar TEXT, totalBayar FLOAT)",
        );
      },
      version: 1,
    );
  }

  insertParkir(Parkir parkiran) async {
    final Database db = await initializeDB();
    await db.insert('parkir_kendaraan', parkiran.toMap());
  }

  updateParkir(Parkir parkiran) async {
    final Database db = await initializeDB();
    await db.update('parkir_kendaraan', parkiran.toMap(), where: 'id=?', whereArgs: [parkiran.id]);
  }

  Future<List<Parkir>> retrieveParkir() async {
    final Database db = await initializeDB();
    List<Parkir> listResult = (await db.query('parkir_kendaraan')).map((e) => Parkir.fromJson(e)).toList();
    return listResult;
  }

  Future<Parkir> readParkir(int idParkir) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('parkir_kendaraan', where: "id = ?", whereArgs: [idParkir]);
    return queryResult.map((e) => Parkir.fromJson(e)).toList().first;
  }

  Future<void> deleteParkir(int id) async {
    final db = await initializeDB();
    await db.delete(
      'parkir_kendaraan',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
