import 'dart:convert';
import 'dart:developer';

import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseVideoModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

List<VideoModel> videodatatasks;

class DatabaseService{
  final String _tasksTableName = "videodownload";
  final String _tasksIdColumnName = "id";
  final String _tasksvideoColumnkey = "videokey";
  final String _tasksVideoColumnTitle = "videotitle";
  final String _tasksVideoColumnStamps = "videostamps";
  final String _tasksVideoColumnNotes = "videonotes";
  final String _tasksVideoColumnPath = "videopath";
  final String _tasksVideoColumnThumbImage = "videothumbimage";
  final String _tasksVideoColumnDuration = "videoduration";
  static Database _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await getDatabase();
    return _db;
  }
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "videodownload_db.db");
    log("Database path: $databasePath");

    try{
      final database = await openDatabase(
        databasePath,
        version: 1,

        onCreate: (db, version) {
          log("Creating table >>>");
          log("Creating table $_tasksTableName");
          db.execute('''
      CREATE TABLE $_tasksTableName (
        $_tasksIdColumnName INTEGER PRIMARY KEY,
        $_tasksvideoColumnkey INTEGER NOT NULL,
        $_tasksVideoColumnTitle VARCHAR NOT NULL,
        $_tasksVideoColumnStamps TEXT NOT NULL,
        $_tasksVideoColumnNotes VARCHAR NOT NULL,
        $_tasksVideoColumnPath VARCHAR NOT NULL,
        $_tasksVideoColumnThumbImage VARCHAR NOT NULL,
        $_tasksVideoColumnDuration VARCHAR NOT NULL
      )
      ''');
          log("Table $_tasksTableName created");
        },
        onOpen: (db) {
          log("Database opened: $db");
        },
      );
      log("Database Exception: $database");
      return database;
    }catch(e){
      log("Database Exception: $e");
    }


  }
  void addTask(String title, int key,String stamps, String notes, String path, String thumbimage, String duration) async {
    final db = await getDatabase();
    log("db>> " + db.toString());
    log(title);
    log(stamps.toString());
    log(notes);
    log(path);
    log("thumbimage>> " + thumbimage);
    log("duration>> " + duration.toString());
    log("Inserting data into $_tasksTableName");

    try {
      await db.insert(
        _tasksTableName,
        {
          _tasksvideoColumnkey: key,
          _tasksVideoColumnTitle: title,
          _tasksVideoColumnStamps: stamps,
          _tasksVideoColumnNotes: notes,
          _tasksVideoColumnPath: path,
          _tasksVideoColumnThumbImage: thumbimage,
          _tasksVideoColumnDuration: duration,
        },
      );
      log("Data inserted successfully");
    } catch (e) {
      log("Error inserting data: $e");
    }
  }
  Future<void> checkTableExists() async {
    final db = await getDatabase();
    final result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='$_tasksTableName'");
    if (result.isNotEmpty) {
      log("Table $_tasksTableName exists.");
    } else {
      log("Table $_tasksTableName does not exist.");
    }
  }
  Future<void> deleteDatabaseIfExists() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "videodownload_db.db");

    log("Deleting existing database at: $databasePath");
    await deleteDatabase(databasePath);
  }
  Future<List<VideoModel>> getTasks() async {
    final db = await database;
    log("get db>> getTasks "+db.toString());
    try{
      final data = await db.query(_tasksTableName);


      videodatatasks = data.map((e) {


        return VideoModel(
          id: e[_tasksIdColumnName] as int,
          videokey: e[_tasksvideoColumnkey] as int,
          videotitle: e[_tasksVideoColumnTitle] as String,
          videostamps: e[_tasksVideoColumnStamps] as String,
          videonotes: e[_tasksVideoColumnNotes] as String,
          videopath: e[_tasksVideoColumnPath] as String,
          videothumbimage: e[_tasksVideoColumnThumbImage] as String,
          videoduration: e[_tasksVideoColumnDuration] as String,
        );
      }).toList();
      // log("data>> tasks length >> "+videodatatasks.length.toString());
      return videodatatasks;
    }catch(e){
      log("get data from database Exception "+e.toString());
    }


  }
  void deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

