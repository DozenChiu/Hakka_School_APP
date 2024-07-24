import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Quiz.db');
    return await openDatabase(path, version: 1);
  }

  Future<List<Map<String, dynamic>>> getReadingData() async {
    final db = await database;
    return await db.query('Reading', orderBy: 'No');
  }

  Future<List<Wordlist>?> getWordlist() async {
    final db = await database;
    final List<String> col = ['Word', 'No'];
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
          num: e["No"] as int
      ),
    ).toList();

    return wordlist;
  }
}

class Wordlist {
  final String word;
  final int num;
  Wordlist({required this.word, required this.num});

  factory Wordlist.fromJson(Map<String, dynamic> json) {
    return Wordlist(
        word: json['Word'] as String,
        num: json['No'] as int
    );
  }
}