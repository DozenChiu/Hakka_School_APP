import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._constructor();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._constructor();

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

// 計算題數
  Future<List<Test>?> getQuestionCount() async {
    final db = await database;
    final data = await db.rawQuery(
        ''' 
        SELECT 'Listen_1' AS table_name, COUNT(*) AS ttl, SUM(CASE WHEN HasCorrected==1 THEN 1 ELSE 0 END) AS correct FROM Listen_1
        UNION ALL
        SELECT 'Listen_2' AS table_name, COUNT(*) AS ttl, SUM(CASE WHEN HasCorrected==1 THEN 1 ELSE 0 END) AS correct FROM Listen_2
        UNION ALL
        SELECT 'Reading' AS table_name, COUNT(*) AS ttl, SUM(CASE WHEN HasCorrected==1 THEN 1 ELSE 0 END) AS correct FROM Reading;
        ''');
    List<Test> test = data.map(
            (e) =>
            Test(
                table: e['table_name'] as String,
                ttl: e['ttl'] as int,
                correct: e['correct'] as int
            )
    ).toList();
    return test;
  }

}
class Test {
  final int ttl;
  final int correct;
  final String table;
  Test(
      {
        required this.ttl,
        required this.table,
        required this.correct
      }
      );
}