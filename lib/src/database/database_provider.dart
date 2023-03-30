import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static Database _database;
  static final DatabaseProvider db = DatabaseProvider._();
  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'florida3.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Pedidos('
          'id VARCHAR PRIMARY KEY,'
          'numero int,'
          'categoria int,'
          'dniU VARCHAR,'
          'nombreU VARCHAR,'
          'dniC VARCHAR,'
          'nombreC VARCHAR,'
          'producto VARCHAR,'
          'cantidad int,'
          'valor double,'
          'creado int,'
          'entregado int,'
          'fecha VARCHAR,'
          'tipoclie int,'
          'dia int,'
          'mes int,'
          'year int'
          ')');
    });
  }
}
