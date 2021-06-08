import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io' as io;

class Connection {
  static Database db;

  static dbPath() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "data5.db");
    return dbPath;
  }

  static checkDatabase() async {
    if (await io.File(await dbPath()).exists()) {
      print('db exists');
      return;
    }

    ByteData data = await rootBundle.load("assets/data.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(await dbPath()).writeAsBytes(bytes);
  }

  static Future<List<Map<String, dynamic>>> query(sql) async {
    if (Connection.db == null) {
      Connection.db = await openDatabase(await dbPath());
    }
    return await Connection.db.rawQuery(sql);
  }
}
