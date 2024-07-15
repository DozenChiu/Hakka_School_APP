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
        backgroundColor: Theme.of(context).colorScheme.primary, // 設置頂部背景顏色為主題的主要顏色
        //title: const Text('學習區'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VocabularyPage()),
                );
              },
              child: const Text('詞彙表'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuestionBankPage()),
                );
              },
              child: const Text('題庫'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}
