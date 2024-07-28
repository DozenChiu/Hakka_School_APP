import 'package:Hakka_School/Pages/question_bank_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Services/audioProvider.dart';
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
      final data = await rootBundle.load('assets/Quiz2.db');
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
    return ChangeNotifierProvider(
        create: (_) => AudioProvider(),
        child: MaterialApp(
        title: 'Flutter Demo', // 設置應用程序的標題
        theme: ThemeData(
        colorScheme:
        ColorScheme.fromSeed(seedColor: Colors.grey.shade200), // 設置應用程序的主題色調
        appBarTheme: const AppBarTheme(color: Colors.blue), // 設置頂部背景顏色為藍色
        useMaterial3: true,
      ),
      home: MyHomePage(), // 設置主頁面為 MyHomePage 小部件
    )
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
          padding: EdgeInsets.all(16.0), // 設置內邊距為16.0
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

