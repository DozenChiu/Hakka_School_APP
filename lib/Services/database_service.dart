import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _db;
  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "demo_asset_quiz.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets/Quiz.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    // open the database
    var db = await openDatabase(path, readOnly: true);
    return db;
  }

  Future<List<Wordlist>?> getWordlist() async {
    final db = await database;
    final List<String> col = ['Word'];
    final data = await db.query(
      "wordList",
      columns: col,
      where: 'Category = ?',
      whereArgs: [3],
    );

    List<Wordlist> wordlist = data
        .map(
          (e) => Wordlist(
        word: e["Word"] as String, // index 命名須對上 column name
      ),
    )
        .toList();

    return wordlist;
  }
}

class Wordlist {
  final String word;

  Wordlist({required this.word});

  factory Wordlist.fromJson(Map<String, dynamic> json) {
    return Wordlist(
      word: json['Word'] as String,
    );
  }
}
