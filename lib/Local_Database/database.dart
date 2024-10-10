import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/Videos.dart'; // Import the video model
import '../Models/Categories.dart'; // Import the category model

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database _database;

  DatabaseHelper._internal();

  // Ensure the database is initialized
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // Initialize the database
  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'videos.db');
    return await openDatabase(
      path,
      version: 1, // If you want to force table creation, increment this version.
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');
    await db.execute('DROP TABLE IF EXISTS videos');
    await db.execute('DROP TABLE IF EXISTS video_categories');
    await _onCreate(db, newVersion); // Call table creation again
  }


  // Create the videos and categories tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE videos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        video_main_category INTEGER,
        video_category_id INTEGER,
        title TEXT,
        thumb_image TEXT,
        video_time TEXT,
        video_text_notes TEXT,
        fee_type INTEGER,
        sort_id INTEGER,
        is_published INTEGER,
        status INTEGER
      )
    ''');

    await db.execute('''
    CREATE TABLE video_categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Changed from BIGINT to INTEGER for SQLite compatibility
      slug VARCHAR(100),
      parent_id INTEGER,
      name VARCHAR(250) NOT NULL,
      description TEXT NOT NULL,
      lecturer_name VARCHAR(250),
      lecturer_about VARCHAR(250),
      fee_type INTEGER,
      meta_title VARCHAR(250) NOT NULL,
      meta_keyword VARCHAR(250) NOT NULL,
      meta_description VARCHAR(250) NOT NULL,
      is_feature INTEGER DEFAULT 0,
      image VARCHAR(250),
      sort_order INTEGER DEFAULT 0,
      status INTEGER DEFAULT 1,
      deleted_at TIMESTAMP,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  ''');
  }

  // Method to initialize the database (call this before using the database)
  Future<void> initializeDatabase() async {
    final db = await database; // This will create the database and table if not exists
  }

  // Insert a video into the database
  Future<void> insertVideo(Video video) async {
    final db = await database;
    await db.insert('videos', video.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCategory(Category category)async{
    final db = await database;
    int result = await db.insert('video_categories', category.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all videos from the database
  Future<List<Video>> getVideos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('videos');
    return List.generate(maps.length, (i) {
      return Video.fromMap(maps[i]);
    });
  }

  Future<List<Category>> getVideosCategory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('video_categories');
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  // Clear all data in the videos table
  Future<void> clearVideos() async {
    final db = await database;
    await db.delete('videos');
  }

  Future<void> clearCategories() async {
    final db = await database;
    await db.delete('video_categories');
  }

  // Fetch child categories based on parent_id
  Future<Map<String, dynamic>> fetchChildCategories(int parentId) async {
    // Validate parent_id
    if (parentId == null) {
      return {
        'status': false,
        'message': "Bad Request",
        'data': {'parent_id': "Required"},
      };
    }

    // Retrieve category data
    final List<Map<String, dynamic>> categoryData = await database.then((db) {
      return db.query(
        'video_categories',
        where: 'id = ? AND status = ?',
        whereArgs: [parentId, 1],
      );
    });

    if (categoryData.isEmpty) {
      return {
        'status': false,
        'message': "Child category not found",
        'data': {
          'attempt_categories': 0,
          'total_categories': 0,
          'lecturer_content': {},
          'second_level': [],
          'third_level': [],
        },
      };
    }

    // Prepare the response
    var categories = {
      'attempt_categories': 0,
      'total_categories': 0,
      'lecturer_content': {
        'lecturer_name': categoryData[0]['lecturer_name'],
        'lecturer_about': categoryData[0]['lecturer_about'],
      },
      'second_level': [],
      'third_level': [],
    };

    // Retrieve subcategories
    final List<Map<String, dynamic>> subCategories = await database.then((db) {
      return db.query(
        'video_categories',
        where: 'parent_id = ? AND status = ?',
        whereArgs: [parentId, 1],
      );
    });

    for (var subCategory in subCategories) {
      // Retrieve videos for this subcategory
      final List<Map<String, dynamic>> videos = await database.then((db) {
        return db.query(
          'videos',
          where: 'video_category_id = ? AND is_published = ?',
          whereArgs: [subCategory['id'], 1],
        );
      });

      // Ensure 'total_categories' is an int and add video count
      categories['total_categories'] = (categories['total_categories'] ?? 0) as int;
      categories['total_categories'] = (categories['total_categories'] as int) + videos.length;

      // Ensure 'second_level' is a List
      if (categories['second_level'] == null || categories['second_level'] is! List) {
        categories['second_level'] = [];
      }
      (categories['second_level'] as List).add({
        'id': subCategory['id'],
        'parent_id': subCategory['parent_id'],
        'category_name': subCategory['name'],
        'total_categories': videos.length,
      });

      // Prepare third-level categories
      var thirdLevelCategory = {
        'id': subCategory['id'],
        'category_name': subCategory['name'],
        'sub_category': [],
      };

      // Ensure 'third_level' is a List
      if (categories['third_level'] == null || categories['third_level'] is! List) {
        categories['third_level'] = [];
      }

      // Add videos to the third-level categories
      for (var video in videos) {
        (thirdLevelCategory['sub_category'] as List).add({
          'id': video['id'],
          'parent_id': video['video_category_id'],
          'category_name': video['title'],
          'video_duration': video['video_time'],
          'video_time': video['video_time'],
          'image': video['thumb_image'],
          'fee_type': video['fee_type'],
          'is_allow': video['fee_type'] == 1 ? false : true, // Example condition for allowance
          'is_subscribe': video['fee_type'] == 2 ? true : false,
          'attempt_date': null,
          'video_status': 2,
          'pause_duration': null,
        });
      }

      (categories['third_level'] as List).add(thirdLevelCategory);
    }

    return {
      'status': true,
      'message': "Child category found",
      'data': categories,
    };
  }

  // Helper function to convert video time to minutes
  String timeToMin(String time) {
    // Implement the logic to convert video time from string to minutes
    int seconds = int.parse(time);
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes minutes';
  }
}
