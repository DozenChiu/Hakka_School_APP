import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'vocabulary_page.dart';

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
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1), // 底部導航欄，選中學習區
    );
  }
}