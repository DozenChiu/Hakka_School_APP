import 'package:flutter/material.dart';
import 'home_page.dart';
import 'learning_area_page.dart';
import 'question_bank_page.dart';
import 'my_vocabulary_page.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LearningAreaPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuestionBankPage()),
        );
        break;
      case 3:
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
          label: '學習區',
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
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey, // 改变未选中状态的颜色
      selectedLabelStyle: TextStyle(color: Colors.amber[800]), // 选中时文字颜色
      unselectedLabelStyle: TextStyle(color: Colors.blue), // 未选中时文字颜色
      onTap: (index) => _onItemTapped(context, index),
    );
  }

}


/*import 'package:flutter/material.dart';
import 'home_page.dart';
import 'learning_area_page.dart';
import 'question_bank_page.dart';
import 'my_vocabulary_page.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LearningAreaPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuestionBankPage()),
        );
        break;
      case 3:
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
          label: '學習區',
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
      selectedItemColor: Colors.amber[800],
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}*/
