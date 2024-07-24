import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
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
                // 點擊按鈕後導航到題庫區頁面
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuestionBankPage()),
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
