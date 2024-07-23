import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '測驗區',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
          children: <Widget>[
            Text(
              '這是測驗區',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2), // 底部導航欄，跳至 “測驗區” 頁面
    );
  }
}