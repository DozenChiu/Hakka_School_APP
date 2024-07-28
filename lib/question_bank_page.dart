import 'package:flutter/material.dart';
import 'dialogue_page.dart';
import 'reading_test_page.dart';
import 'single_sentence_page.dart';
import 'bottom_nav_bar.dart';

class QuestionBankPage extends StatelessWidget {
  const QuestionBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '題庫',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '聽力能力',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // 添加一個高度為20的空間
              ElevatedButton.icon(
                icon: const Icon(Icons.hearing), // 設置按鈕左側的圖標
                label: const Text('單句'), // 設置按鈕文字
                onPressed: () {
                  // 當按鈕被按下時導航到單句頁面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SingleSentencePage()),
                  );
                },
              ),
              const SizedBox(height: 10), // 添加一個高度為10的空間
              ElevatedButton.icon(
                icon: const Icon(Icons.hearing), // 設置按鈕左側的圖標
                label: const Text('對話'), // 設置按鈕文字
                onPressed: () {
                  // 當按鈕被按下時導航到對話頁面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DialoguePage()), // 創建導航到 DialoguePage 頁面
                  );
                },
              ),
              const SizedBox(height: 40), // 添加一個高度為40的空間，分隔不同類別
              const Text(
                '閱讀能力',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // 添加一個高度為20的空間
              ElevatedButton.icon(
                icon: const Icon(Icons.book), // 設置按鈕左側的圖標
                label: const Text('閱測'), // 設置按鈕文字
                onPressed: () {
                  // 當按鈕被按下時導航到閱測頁面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReadingTestPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1), // 底部導航欄
    );
  }
}