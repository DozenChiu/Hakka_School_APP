import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // 設置頂部背景顏色為主題的主要顏色
        //title: const Text('首頁'),
        title: const Text(
          '首頁',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: Center(
        child: const Text('這是首頁'),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }
}
