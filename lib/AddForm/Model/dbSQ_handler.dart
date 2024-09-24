// ignore_for_file: camel_case_types

import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_client/AddForm/notes.dart';

class DB_Helper {
  static Database? _db;

// Database Singleton: The DB_Helper class ensures that only one instance of the database is created and used throughout the application using the _db static variable and db getter method. If _db is not initialized (null), it calls initDatabase to create the database.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

// i) getApplicationDocumentsDirectory: This method from path_provider package gets the path to the app's documents directory.
// ii) join: This method from the path package constructs the path to the database file by joining the documents directory path with 'notes.db'.
// iii) openDatabase: This method opens the database at the given path. If the database does not exist, it will be created, and the onCreate callback will be executed.
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

// _onCreate: This callback is called when the database is created for the first time. It executes an SQL statement to create the notes table with columns: id, title, age, description, and email.
  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,age TEXT NOT NULL, description TEXT NOT NULL, email TEXT)",
    );
  }

// i) insert: This method inserts a new NotesModel object into the notes table.
// ii) toMap: This method (assumed to be defined in NotesModel) converts the NotesModel object into a map where keys are column names and values are column values.
  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbClient = await db;
    await dbClient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

// i) getNotesList: This method fetches all records from the notes table.
// ii) query: This method retrieves all rows from the notes table.
// iii) fromMap: This method (assumed to be defined in NotesModel) converts a map into a NotesModel object.
  Future<List<NotesModel>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('notes');
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

// i) noteDelete: This method deletes a note from the notes table where the id matches the provided id.    ii) delete: This method deletes rows from the notes table based on the specified condition.
  Future<int> noteDelete(int id) async {
    var dbClient = await db;
    return dbClient!.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

// i) updateNotes: This method updates a note in the notes table.
// ii) update: This method updates rows in the notes table where the id matches the id of the provided notesModel.
  Future<int> updateNotes(NotesModel notesModel) async {
    var dbClient = await db;
    return dbClient!.update('notes', notesModel.toMap(),
        where: 'id = ?', whereArgs: [notesModel.id]);
  }
}
