import 'package:flutter/material.dart';
import 'learning_area_page.dart';
import 'quiz_page.dart';

void main() {
  runApp(const MyApp()); // 應用程序的入口點，運行 MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // 設置應用程序的標題
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // 設置應用程序的主題色調
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hakka_app Home Page'), // 設置主頁面為 MyHomePage 小部件
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // 定義頁面標題的變量

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // 設置頂部背景顏色為主題的主要顏色
        title: Text(title, style: TextStyle(color: Colors.white)), // 設置頂部標題文字和顏色
        centerTitle: true, // 設置頂部標題居中
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 設置內邊距為16.0
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
            children: <Widget>[
              const Text(
                '歡迎來到主頁', // 顯示歡迎文字
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),  // 設置文字大小和加粗
              ),
              const SizedBox(height: 20), // 添加一個高度為20的空間
              ElevatedButton.icon(
                icon: Icon(Icons.book), // 設置按鈕左側的圖標
                label: const Text('學習區'), // 設置按鈕文字
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),  // 設置按鈕內邊距
                  textStyle: TextStyle(fontSize: 18),  // 設置按鈕文字大小
                ),
                onPressed: () {
                  // 當按鈕被按下時導航到學習區頁面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LearningAreaPage()),
                  );
                },
              ),
              const SizedBox(height: 20), // 添加一個高度為20的空間
              ElevatedButton.icon(
                icon: Icon(Icons.quiz), // 設置按鈕左側的圖標
                label: const Text('測驗區'), // 設置按鈕文字
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),  // 設置按鈕內邊距
                  textStyle: TextStyle(fontSize: 18), // 設置按鈕文字大小
                ),
                onPressed: () {
                  // 當按鈕被按下時導航到測驗區頁面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}