import 'package:Hakka_School/Pages/question_bank_page.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'my_vocabulary_page.dart';
import 'quiz_page.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  // 定義點擊底部導航欄項目後執行的操作
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case -1: // 跟現在的頁碼相同，do nothing
        break;
      case 0: // 導航到主頁面
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
        break;
      case 1: // 導航到學習區頁面
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuestionBankPage()),
        );
        break;
      case 2: // 導航到測驗區頁面
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizPage()),
        );
        break;
      case 3: // 導航到我的單字頁面
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyVocabularyPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首頁',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: '題庫',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: '測驗區',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: '我的單字',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber[800], // 已選中項目的顏色
      unselectedItemColor: Colors.grey, // 未選中項目的顏色
      selectedLabelStyle: TextStyle(color: Colors.amber[800]), // 已選中項目的文字顏色
      unselectedLabelStyle: const TextStyle(color: Colors.blue), // 未選中項目的文字顏色
      onTap: (index) => _onItemTapped(
          context, index != selectedIndex ? index : -1), // 點擊項目後調用的方法，後面塞判斷式
    );
  }
}
