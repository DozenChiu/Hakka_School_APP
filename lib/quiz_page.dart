import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '測驗區',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
          children: <Widget>[
            const Text(
              '這是測驗區',
            ),
            const SizedBox(height: 20), // 添加一個高度為20的空間
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),// 底部導航欄，點選後跳至“我的單字”頁面
    );
  }
}