// ignore_for_file: prefer_is_empty, non_constant_identifier_names, camel_case_types

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

import 'package:sqlite_client/stepper_Form/Model/photo.dart';

class DB_Main {
  static Database? data_M;
  static String id = 'id';
  static String name = 'photoName';
  static String table = 'stepperT';
  static String DB_Name = 'stepper.db';

  Future<Database?> get db async {
    if (data_M != null) {
      return data_M;
    }
    data_M = await initDb();
    return data_M;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table (id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT NOT NULL, lastName TEXT NOT NULL,email TEXT NOT NULL, mNumber TEXT NOT NULL, cityName TEXT NOT NULL, photoName TEXT NOT NULL )");
  }

  Future<form_Model> save(form_Model employee) async {
    var dbClient = await db;
    employee.id = await dbClient!.insert(table, employee.toMap());
    return employee;
  }

  Future<List<form_Model>> getPhotos() async {
    var dbClient = await db;
    List<Map> maps = await dbClient!.query(table, columns: [
      'id',
      'firstName',
      'lastName',
      'email',
      'mNumber',
      'cityName',
      'photoName'
    ]);
    List<form_Model> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(form_Model.fromMap(Map<String, dynamic>.from(maps[i])));
      }
    }
    return employees;
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
