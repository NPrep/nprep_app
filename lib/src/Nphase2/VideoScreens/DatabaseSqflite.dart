import 'dart:convert';
import 'dart:developer';

import 'package:n_prep/src/Nphase2/VideoScreens/DatabaseVideoModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

List<VideoModel> videodatatasks;
List<VideoModel> beforevideodatatasks;
List beforeSingleTaskData = [];
List questionArray = [];
List questionArrayinfo = [];

class DatabaseService{
  final String _tasksTableName = "videodownload";
  final String _tasksdownloadstart = "downloadstart";
  final String _questiondataarray = "questiondata";
  final String _questionexaminfo = "examinfo";
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

          ///_tasksTableName
          db.execute('''
                CREATE TABLE $_tasksTableName (
                  $_tasksIdColumnName INTEGER PRIMARY KEY,
                  $_tasksvideoColumnkey INTEGER NOT NULL,
                  $_tasksVideoColumnTitle VARCHAR NOT NULL,
                  $_tasksVideoColumnStamps VARCHAR NOT NULL,
                  $_tasksVideoColumnNotes VARCHAR NOT NULL,
                  $_tasksVideoColumnPath VARCHAR NOT NULL,
                  $_tasksVideoColumnThumbImage VARCHAR NOT NULL,
                  $_tasksVideoColumnDuration VARCHAR NOT NULL
                )
          ''');

          ///_tasksdownloadstart
          db.execute('''
                CREATE TABLE $_tasksdownloadstart (
                  $_tasksIdColumnName INTEGER PRIMARY KEY,
                  $_tasksvideoColumnkey INTEGER NOT NULL,
                  $_tasksVideoColumnTitle VARCHAR NOT NULL,
                  $_tasksVideoColumnStamps VARCHAR NOT NULL,
                  $_tasksVideoColumnNotes VARCHAR NOT NULL,
                  $_tasksVideoColumnPath VARCHAR NOT NULL,
                  $_tasksVideoColumnThumbImage VARCHAR NOT NULL,
                  $_tasksVideoColumnDuration VARCHAR NOT NULL
                )
                ''');
          db.execute('''
                CREATE TABLE $_questiondataarray (
                  id INTEGER PRIMARY KEY,
                  is_attempt TEXT,
                  your_answer TEXT
                )
                ''');

          db.execute('''
                CREATE TABLE $_questionexaminfo (
                  examid TEXT,
                  id TEXT,
                  type TEXT
                )
                ''');
          log("Table>> $_tasksTableName created");
          log("Table>> $_tasksdownloadstart created");
          log("Table>> $_questiondataarray created");
          log("Table>> $_questionexaminfo created");
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

  void addbeforeTask(String title, int key,String stamps, String notes, String path, String thumbimage, String duration) async {
    final db = await getDatabase();
    log("db>> " + db.toString());
    log("title >> "+title);
    log("Video key >> " + key.toString());
    log("stamps >> "+stamps.toString());
    log("notes >> "+notes);
    log("path >> "+path);
    log("thumbimage >> " + thumbimage);
    log("duration >> " + duration.toString());
    log("Inserting data into $_tasksdownloadstart");

    try {
      await db.insert(
        _tasksdownloadstart,
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
      getbeforeTask();
      log("Data inserted addbeforeTask successfully");
    } catch (e) {
      log("Error inserting addbeforeTask data: $e");
    }
  }
  void getbeforeTask() async {
    final db = await database;
    log("get db>> getbeforeTask "+db.toString());
    try{
      final data = await db.query(_tasksdownloadstart);

      log("TaskArray>> getbeforeTask >> "+data.toString());
      log("TaskArray>> getbeforeTask >> "+data.length.toString());

      }catch(e){
      log("get data getbeforeTask Exception "+e.toString());
    }


  }
  void deletebeforeTask(int id) async {
    final db = await database;
    await db.delete(
      _tasksdownloadstart,
      where: 'videokey = ?',
      whereArgs: [id],
    );
    getbeforeTask();
  }
  Future<bool> beforeTaskExists(int id) async {
    final db = await database;

    // Query the database for the row with the specified id
    List<Map<String, dynamic>> result = await db.query(
      _tasksdownloadstart,
      where: 'videokey = ?',
      whereArgs: [id],
    );

    // If the result list is not empty, the entry exists
    return result.isNotEmpty;
  }
  void GetSingleDataTaskExists(int id) async {
    final db = await database;

    // Query the database for the row with the specified id
    var result = await db.query(
      _tasksdownloadstart,
      where: 'videokey = ?',
      whereArgs: [id],
    );
    beforeSingleTaskData.clear();
    beforeSingleTaskData.addAll(result);
    // If the result list is not empty, the entry exists
    //[{id: 1, videokey: 8, videotitle: Breast Pathology,
    // videostamps: [],
    // videonotes: /data/user/0/com.n_prep.medieducation/app_flutter/17079125938883.pdf,
    // videopath: /data/user/0/com.n_prep.medieducation/app_flutter/17072359093283.MP4,
    // videothumbimage: /data/user/0/com.n_prep.medieducation/app_flutter/17071650593560.jpg,
    // videoduration: 00:25:30}]
    log("TaskArray>> GetSingleDataTaskExists >> "+beforeSingleTaskData[0]['videotitle'].toString());
    log("TaskArray>> GetSingleDataTaskExists >> "+beforeSingleTaskData.length.toString());

  }

  // Insert question data
  Future<void> insertQuestionData(int id, int isAttempt, String yourAnswer) async {
    final db = await database;
    await db.insert(
      _questiondataarray,
      {
        'id': id,
        'is_attempt': isAttempt,
        'your_answer': yourAnswer,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }
  // Update a question's data
  Future<void> updateQuestionData(int id, int isAttempt, String yourAnswer) async {
    final db = await database;

    // Prepare the updated data
    Map<String, dynamic> updatedData = {
      'is_attempt': isAttempt,
      'your_answer': yourAnswer,
    };

    // Update the row that matches the id
    await db.update(
      _questiondataarray,
      updatedData,
      where: 'id = ?',
      whereArgs: [id],
    );
    getExamQuestion();
  }
  // Insert exam info
  Future<void> insertExamInfo(String examid, String id, String type) async {
    final db = await database;
    await db.insert(
      _questionexaminfo,
      {
        'examid': examid,
        'id': id,
        'type': type,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    getExamQuestion();
  }
  Future<List> getExamQuestion() async {
    final db = await database;
    log("get db>> getTasks "+db.toString());
    try{
      final data = await db.query(_questiondataarray);
      final datas = await db.query(_questionexaminfo);

      questionArray.clear();
      questionArrayinfo.clear();
      questionArray.addAll(data);
      questionArrayinfo.addAll(datas);
      log("questionArray>> _questiondataarray length >> "+questionArray.length.toString());
      log("questionArray>> _questiondataarray >> "+questionArray.toString());
      log("questionArray>> _questionexaminfo >> "+datas.toString());
      return questionArray;
    }catch(e){
      log("get questionArray Exception "+e.toString());
    }


  }



  Future<void> deleteDatabaseIfExists() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "videodownload_db.db");

    log("Deleting existing database at: $databasePath");
    await deleteDatabase(databasePath);
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
  void deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void deleteExamTask() async {
    final db = await database;
    await db.delete(
      _questionexaminfo,
    );
    await db.delete(
      _questiondataarray,
    );
    log("Table>> $_questiondataarray deleted");
    log("Table>> $_questionexaminfo deleted");
  }

}

