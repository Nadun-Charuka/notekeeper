import 'dart:io';

import 'package:notekeeperapp/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; //Singleton DatabseHelper
  DatabaseHelper._createInstance();

  static Database? _database;
  String noteTable = 'note_table';
  String colId = 'Id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colData = 'data';

  factory DatabaseHelper() {
    _databaseHelper ??=
        DatabaseHelper._createInstance(); // Initialize only if null
    return _databaseHelper!;
  }

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';

    var noteDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return noteDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''create table $noteTable(
                      $colId int AI primary key,
                      $colTitle varchar(30),
                      $colDescription text,
                      $colPriority int,
                      $colData text)''');
  }

  // ```````````````````````CRUD`````````````````````````````

  //fetch data
  Future<List<Map<String, dynamic>>?> getNoteMapList() async {
    Database? db = await database;
    //var result = await db?.rawQuery('select * from $noteTable');
    var result = await db?.query(noteTable); //helper funciton query
    return result;
  }

  //insert data
  Future<int> insertNote(Note note) async {
    Database? db = await database;
    var result = await db!.insert(noteTable, note.toMap());
    return result;
  }

  //update data
  Future<int> updateNote(Note note) async {
    Database? db = await database;
    var result = await db!.update(noteTable, note.toMap(),
        where: '$colId =?', whereArgs: [note.id]);
    return result;
  }

  //delete data
  Future<int> deleteNote(int id) async {
    Database? db = await database;
    // var result =
    //     await db!.delete(noteTable, where: '$colId =?', whereArgs: [note.id]);
    int result = await db!.rawDelete('delet from $noteTable where $colId=$id');
    return result;
  }

  //get number of note objects in db
  Future<int?> getCount() async {
    Database? db = await database;
    List<Map<String, dynamic>> x =
        await db!.rawQuery("select count(*) from $noteTable");

    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList!.length;
    List<Note> noteList = <Note>[];
    for (var i = 0; i < count; i++) {
      noteList.add(Note.fromMap(noteMapList[i]));
    }
    return noteList;
  }
}
