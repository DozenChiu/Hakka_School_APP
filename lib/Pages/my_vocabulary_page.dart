import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class MyVocabularyPage extends StatelessWidget {
  const MyVocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '我的單字',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: const Center(
        child: Text('這是我的單字頁面'), // 中心顯示文字
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),// 底部導航欄，點選後跳至“我的單字”頁面
    );
  }
}