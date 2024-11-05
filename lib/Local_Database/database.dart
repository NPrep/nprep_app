import 'dart:developer';
import 'package:n_prep/constants/validations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/AllCategory.dart';
import '../Models/Exam.dart';
import '../Models/Videos.dart'; // Import the video model
import '../Models/Categories.dart'; // Import the category model

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'videos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');
    await db.execute('DROP TABLE IF EXISTS videos');
    await db.execute('DROP TABLE IF EXISTS video_categories');
    await db.execute('DROP TABLE IF EXISTS exam');  // Drop exam table during upgrade
    await _onCreate(db, newVersion);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the videos table
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

    // Create the video_categories table
    await db.execute('''
    CREATE TABLE video_categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
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

    // Create the categories table
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        slug TEXT,
        parent_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        fee_type INTEGER,
        meta_title TEXT,
        meta_keyword TEXT,
        meta_description TEXT,
        is_feature INTEGER DEFAULT 0,
        is_mixed INTEGER DEFAULT 0,
        image TEXT,
        sort_order INTEGER DEFAULT 0,
        status INTEGER DEFAULT 1,
        deleted_at TIMESTAMP,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        total_questions INTEGER DEFAULT 0
      )
    ''');

    // Create the exam table
    await db.execute('''
      CREATE TABLE exam (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image VARCHAR(250),
        exam_type INTEGER NOT NULL,
        subject INTEGER,
        title VARCHAR(255) NOT NULL,
        fee_type INTEGER DEFAULT 2,
        exam_year YEAR NOT NULL,
        user_tag INTEGER,
        exam_duration INTEGER,
        description TEXT NOT NULL,
        sort_order INTEGER DEFAULT 0,
        status INTEGER DEFAULT 1,
        is_published TINYINT DEFAULT 0,
        deleted_at TIMESTAMP,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> initializeDatabase() async {
    final db = await database;
  }

  // Insert a video
  Future<void> insertVideo(Video video) async {
    final db = await database;
    await db.insert('videos', video.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert an exam
  Future<void> insertExam(Exam exam) async {
    final db = await database;
    await db.insert('exam', exam.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearExams() async {
    final db = await database;
    await db.delete('exam');
  }

  Future<void> insertCategory(Category category)async{
    final db = await database;
    int result = await db.insert('video_categories', category.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAllCategory(AllCategory allCategory)async{
    final db = await database;
    int result = await db.insert('categories', allCategory.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
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

  Future<void> clearVideos() async {
    final db = await database;
    await db.delete('videos');
  }

  Future<void> clearCategories() async {
    final db = await database;
    await db.delete('video_categories');
  }

  Future<void> clearQBankCategories() async {
    final db = await database;
    await db.delete('categories');
  }

  Future<Map<String, dynamic>> fetchAllCategories(int parentId) async {
    // Validate parentId
    if (parentId == null) {
      return {
        'status': false,
        'message': "Bad Request",
        'data': {'parent_id': "Required"},
      };
    }

    // Retrieve all parent categories (matching parentId)
    final List<Map<String, dynamic>> parentCategories = await database.then((db) {
      return db.query(
        'categories',
        where: 'parent_id = ? AND status = ? AND name <> ?',
        orderBy: 'sort_order asc',
        whereArgs: [parentId, 1, 'Mix questions others'], // Use the provided parentId
      );
    });

    if (parentCategories.isEmpty) {
      return {
        'status': false,
        'message': "No categories found",
        'data': {
          'second_level': [],
          'third_level': [],
        },
      };
    }

    // Prepare the response structure
    var categories = {
      'second_level': [],
      'third_level': [],
    };

    for (var parentCategory in parentCategories) {
      // Retrieve subcategories for each parent category
      final List<Map<String, dynamic>> subCategories = await database.then((db) {
        return db.query(
          'categories',
          where: 'parent_id = ? AND status = ? AND name <> ?',
          orderBy: 'sort_order asc',
          whereArgs: [parentCategory['id'], 1, "Mix questions"],
        );
      });

      // If no subcategories are found, skip this parent category
      if (subCategories.isEmpty) {
        continue; // Skip this loop iteration, so this category won't be added
      }

      // Prepare second level category data
      var secondLevelData = {
        'id': parentCategory['id'],
        'parent_id': parentCategory['parent_id'],
        'category_name': parentCategory['name'],
        'total_categories': 0,
        'sub_category': [], // Initialize sub_category list
      };

      for (var subCategory in subCategories) {
        // Prepare subcategory data
        var subCategoryData = {
          'id': subCategory['id'],
          'parent_id': subCategory['parent_id'],
          'category_name': subCategory['name'],
          'image': subCategory['image'],
          'fee_type': subCategory['fee_type'],
          'total_attempt_test': 0, // Adjust as needed
          'total_questions': subCategory['total_questions'], // Adjust as needed
          'attempt_questions': 0, // Adjust as needed
          'completed_date': null, // Adjust as needed
          'exam_status': 1, // Adjust as needed
        };

        // Add subcategory to the sub_category list
        (secondLevelData['sub_category'] as List).add(subCategoryData);
        secondLevelData['total_categories'] += 1; // Increment total categories count for the second level
      }

      // Add second level data to the main categories structure
      (categories['second_level'] as List).add(secondLevelData);

      // Prepare third-level category structure
      var thirdLevelCategory = {
        'id': secondLevelData['id'],
        'category_name': secondLevelData['category_name'],
        'sub_category': secondLevelData['sub_category'],
      };

      // Add the third-level category to the main categories structure
      (categories['third_level'] as List).add(thirdLevelCategory);
    }

    // Debugging outputs
    print("Second Level Categories: ${categories['second_level']}");
    print("Third Level Categories: ${categories['third_level']}");

    return {
      'status': true,
      'message': "Categories found",
      'data': categories,
    };
  }







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
        orderBy: 'sort_order asc',
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
        orderBy: 'sort_order asc',
        whereArgs: [parentId, 1],
      );
    });

    // If there are no subcategories, skip adding this parent category
    if (subCategories.isEmpty) {
      return {
        'status': true,
        'message': "No subcategories found for this category",
        'data': categories,
      };
    }

    bool hasVideos = false;  // Flag to check if any videos are found

    for (var subCategory in subCategories) {
      // Retrieve videos for this subcategory
      final List<Map<String, dynamic>> videos = await database.then((db) {
        return db.query(
          'videos',
          where: 'video_category_id = ? AND is_published = ?',
          whereArgs: [subCategory['id'], 1],
        );
      });

      // If no videos found for this subcategory, skip it
      if (videos.isEmpty) {
        continue;
      }

      // At least one video is found, so set the flag
      hasVideos = true;

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

    // If no videos are found for any subcategory, skip adding this parent category
    if (!hasVideos) {
      return {
        'status': true,
        'message': "No videos found for this category",
        'data': {
          'attempt_categories': 0,
          'total_categories': 0,
          'lecturer_content': categories['lecturer_content'],
          'second_level': [],
          'third_level': [],
        },
      };
    }

    return {
      'status': true,
      'message': "Child category found",
      'data': categories,
    };
  }


  Future<Map<String, dynamic>> fetchAndDisplayFilteredExams(int parentId) async {
    try {
      // Query the 'exams' table with the correct condition
      final List<Map<String, dynamic>> filteredExams = await database.then((db) {
        return db.query(
          'exam', // Ensure the correct table name
          where: 'subject = ? AND exam_type = ?', // Filtering by subject and exam_type
          whereArgs: [parentId, 3], // Arguments for filtering (parentId for subject, 3 for exam_type)
        );
      });

      var data = [];

      // Check if there are any exams to display
      if (filteredExams.isNotEmpty) {
        for (var exam in filteredExams) {

          var thirdLevelCategory = {
            'id' : exam['id'],
            'title' : exam['title'],
            'exam_duration' : exam['exam_duration'],
            'fee_type' : exam['fee_type'],
            'MCQs' : exam['total_mcqs']==null?"":exam['total_mcqs'],
            'last_attempt_result_id' : "",
            'last_attempt_result_date' : "",
          };

          (data as List).add(thirdLevelCategory);
        }

        return {
          'status': true,
          'message': "Child category found",
          'data': data,
        };
      } else {
        print("No exams found for the given subject and exam type.");
      }

    } catch (e) {
      print("Error: $e");
    }
  }
}
