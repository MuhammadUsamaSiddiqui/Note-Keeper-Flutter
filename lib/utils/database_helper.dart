import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io'; // To deal with files and Folders
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper_app/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  // Tablename with Fields name
  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    // factory with constructor, return some value

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    // Open/Create a database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        ' $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  // Read
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority ASC');
    //var result = await db.query(noteTable,orderBy: '$colPriority ASC');
    return result;
  }

  // Insert
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // Get Number of Note Objects in Database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $noteTable');

    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the Map List  and convert it into Note List
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // get Map List from Database
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();

    // Loop to create a Note List from Map List
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
