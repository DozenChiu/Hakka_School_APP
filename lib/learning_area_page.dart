import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'vocabulary_page.dart';
import 'question_bank_page.dart';

class LearningAreaPage extends StatelessWidget {
  const LearningAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '學習區',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // 點擊按鈕後導航到詞彙表頁面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VocabularyPage()),
                );
              },
              child: const Text('詞彙表'),
            ),
            const SizedBox(height: 20), // 添加一個高度為20的空間
            ElevatedButton(
              onPressed: () {
                // 點擊按鈕後導航到題庫區頁面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuestionBankPage()),
                );
              },
              child: const Text('題庫區'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1), // 底部導航欄
    );
  }
}