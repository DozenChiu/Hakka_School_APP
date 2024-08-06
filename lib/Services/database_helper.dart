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

// 產生題庫 list
  Future<List<Question>?> fetchQuestion(String table) async {
    final db = await database;
    final favoriteRows = await db.query('favorite', columns: ['No'], where: 'Name=?', whereArgs: [table]);
    final favoriteSet = favoriteRows.map((row) => row['No'] as int).toSet();
    final pair = await db.query(table, orderBy: 'No');
    final List<Question> pairToList = pair.map((e)=>
    Question(
        num: e['No'] as int,
        text: e['Questions'] as String,
        opt: [e['Option_1'] as String, e['Option_2'] as String, e['Option_3'] as String],
        ans: e['Answer'] as int,
        pic: e['HasPic'] as int,
        table: table,
        isFavorite: favoriteSet.contains(e['No']))
    ).toList();
    return pairToList;
  }

// 計算答題狀況
  Future<List<Progress>?> getQuestionCount() async {
    final db = await database;
    final data = await db.rawQuery('''
        SELECT 'Listen_1' AS table_name, COUNT(*) AS ttl, SUM(CASE WHEN HasCorrected==1 THEN 1 ELSE 0 END) AS correct FROM Listen_1
        UNION ALL
        SELECT 'Listen_2' AS table_name, COUNT(*) AS ttl, SUM(CASE WHEN HasCorrected==1 THEN 1 ELSE 0 END) AS correct FROM Listen_2
        UNION ALL
        SELECT 'Reading' AS table_name, COUNT(*) AS ttl, SUM(CASE WHEN HasCorrected==1 THEN 1 ELSE 0 END) AS correct FROM Reading;
        ''');
    List<Progress> p = data.map(
            (e) =>
                Progress(
                table: e['table_name'] as String,
                ttl: e['ttl'] as int,
                correct: e['correct'] as int
            )
    ).toList();
    return p;
  }

  // favorite 插入
  Future<void> insertFavorite(String table, int no) async {
    final db = await database;
    // 檢查是否已經存在相同的記錄
    final  pair = await db.query(
      'favorite',
      where: 'Name = ? AND No = ?',
      whereArgs: [table, no]
    );
    // 如果記錄已經存在，則返回
    if (pair.isNotEmpty) {
      return;
    }
    // 插入新的收藏記錄
    await db.insert(
        'favorite',
        {'Name': table, 'No': no},
      conflictAlgorithm: ConflictAlgorithm.ignore, // 避免插入時衝突
    );
  }

  // 產生 my_favorite.dart 需要的 list
  Future<List<Question>?> fetchMyFavorite() async{
    final db = await database;
    final pair = await db.rawQuery('''
    SELECT
      favorite.No,
      coalesce(Listen_1.Questions, Listen_2.Questions, Reading.Questions) AS Q,
      coalesce(Listen_1.Option_1, Listen_2.Option_1, Reading.Option_1) AS opt1,
      coalesce(Listen_1.Option_2, Listen_2.Option_2, Reading.Option_2) AS opt2,
      coalesce(Listen_1.Option_3, Listen_2.Option_3, Reading.Option_3) AS opt3,
      coalesce(Listen_1.Answer, Listen_2.Answer, Reading.Answer) AS ans,
      coalesce(Listen_1.HasPic, Listen_2.HasPic, Reading.HasPic) AS pic,
      favorite.Name
    FROM favorite
    LEFT JOIN Listen_1 ON favorite.No = Listen_1.No AND favorite.Name = 'Listen_1'
    LEFT JOIN Listen_2 ON favorite.No = Listen_2.No AND favorite.Name = 'Listen_2'
    LEFT JOIN Reading ON favorite.No = Reading.No AND favorite.Name = 'Reading'
    ORDER BY favorite.id DESC;
    ''');

    final List<Question> pairToList = pair.map((e)=>
    Question(
      num: e['No'] as int,
      text: e['Q'] as String,
      opt: [e['opt1'] as String,e['opt2'] as String,e['opt3'] as String],
      ans: e['ans'] as int,
      pic: e['pic'] as int,
      table: e['Name'] as String,
    )
    ).toList();
    return pairToList;
  }

  // 刪除 favorite 的特定題目
  Future<void> removeFavoriteData(String table, int no) async {
    final db = await database;
    db.delete('favorite', where: 'Name=? AND No = ?', whereArgs: [table, no]);
  }

}
// 答對的資料型態
class Progress {
  final int ttl;
  final int correct;
  final String table;
  Progress(
      {
        required this.ttl,
        required this.table,
        required this.correct
      }
  );
}
// favorite 的資料型態
class Like {
  final int? num;
  final String? table;
  Like ({required this.table, required this.num});
}

// 題目需要的格式
class Question {
  final int num;
  final String text;
  final List<String> opt;
  final int ans;
  final int pic;
  final String table;
  bool isFavorite;
  Question (
  {
    required this.num,
    required this.text,
    required this.opt,
    required this.ans,
    required this.pic,
    required this.table,
    this.isFavorite = false,
  }
  );
}