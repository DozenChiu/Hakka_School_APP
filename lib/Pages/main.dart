import 'package:Hakka_School/Pages/my_favorite.dart';
import 'package:Hakka_School/Pages/quiz_records_page.dart';
import 'package:Hakka_School/Theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'bottom_nav_bar.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'incorrect_questions_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // 複製資料庫
  await _copyDatabaseFromAssets();

  final dbPath = await databaseFactory.getDatabasesPath();
  final path = join(dbPath, 'Quiz.db');
  final database = await databaseFactory.openDatabase(path);

  // 初始化資料庫表格
  await _createDatabaseTables(database);
  runApp(const MyApp()); // 應用程序的入口點，運行 MyApp
}

Future<void> _createDatabaseTables(Database database) async {
  // 建立 quiz_record 表，用來記錄每次測驗題目和選項
  await database.execute('''
    CREATE TABLE IF NOT EXISTS quiz_record (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_name TEXT,
      question_id INTEGER,
      user_answer INTEGER,
      correct_answer INTEGER,
      Test_id INTEGER
    )
  ''');
  // 建立 quiz_error 表，用來記錄每次測驗的錯誤題目
  await database.execute('''
    CREATE TABLE IF NOT EXISTS quiz_error (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_name TEXT,
      question_id INTEGER,
      user_answer INTEGER,
      correct_answer INTEGER
    )
  ''');
  // 建立 quiz_score 表，用來記錄每次測驗的成績
  await database.execute('''
    CREATE TABLE IF NOT EXISTS quiz_score (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      score REAL,
      timestamp TEXT
    )
  ''');
}

Future<void> _copyDatabaseFromAssets() async {
  final dbPath = await databaseFactory.getDatabasesPath();
  final path = join(dbPath, 'Quiz.db');

  // 檢查資料庫文件是否已經存在
  final exists = await File(path)
      .exists(); //print('Database path: $path'); print('Database exists: $exists');

  if (!exists) {
    // 資料庫文件不存在，從assets文件夾複製
    // 檢查並創建目標目錄
    final directory = Directory(dbPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    try {
      final data = await rootBundle.load('assets/Quiz.db');
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print('Database copied successfully.');
    } catch (e) {
      print("Error copying database: $e");
    }
  } else {
    print('Database file already exists.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo', // 設置應用程序的標題
        theme: lightMode,
        home: MyHomePage(), // 設置主頁面為 MyHomePage 小部件
      );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 設置頂部背景顏色為主題的主要顏色
        title: const Text(
          '首頁',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 設置內邊距為16.0
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
            children: <Widget>[
              const Text(
                '歡迎來到主頁', // 顯示歡迎文字
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold), // 設置文字大小和加粗
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                label: const Text('查看測驗紀錄'),
                onPressed: () {
                Navigator.push(
                context,
              MaterialPageRoute(builder: (context) => QuizRecordPage()),
                );
                },
              ),
              const SizedBox(height: 20), // 添加一個高度為20的空間
              ElevatedButton.icon(
                label: const Text('查看錯誤題目'),
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IncorrectQuestionsPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  label: const Text("我的題目"),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyFavorite()),
                    );
                  }
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  label: const Text("關於"),
                    onPressed: (){
                    showAlertDialog(context);
                  }
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0), // 底部導航欄
    );
  }
  Future<void> showAlertDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade100,
          title: const Text('網站連結'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => launchUrlString('https://hakkaexam.hakka.gov.tw/hakka/'),
                child: const Text(
                  '報名考試',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () => launchUrlString('https://hakkadict.moe.edu.tw/'),
                child: const Text(
                  '客語字典',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Text('了解', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

