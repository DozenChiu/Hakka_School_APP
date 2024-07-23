import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // 複製資料庫
  await _copyDatabaseFromAssets();

  final dbPath = await databaseFactory.getDatabasesPath();
  final path = join(dbPath, 'Quiz.db');
  final db = await databaseFactory.openDatabase(path);

  runApp(const MyApp()); // 應用程序的入口點，運行 MyApp
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
      title: 'Flutter Demo', // 設置應用程序的標題
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.orange), // 設置應用程序的主題色調
        appBarTheme: const AppBarTheme(color: Colors.blue // 設置頂部背景顏色為藍色
            ),
        useMaterial3: true,
      ),
      home: const MyHomePage(), // 設置主頁面為 MyHomePage 小部件
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0), // 設置內邊距為16.0
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
            children: <Widget>[
              Text(
                '歡迎來到主頁', // 顯示歡迎文字
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold), // 設置文字大小和加粗
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0), // 底部導航欄
    );
  }
}
