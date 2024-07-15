import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class MyVocabularyPage extends StatelessWidget {
  const MyVocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // 設置頂部背景顏色為主題的主要顏色
        //title: const Text('我的單字'),
        title: const Text(
          '我的單字',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: Center(
        child: const Text('這是我的單字頁面'),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
    );
  }
}
