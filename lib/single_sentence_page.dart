import 'package:flutter/material.dart';

class SingleSentencePage extends StatelessWidget {
  const SingleSentencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold 是一個 Material Design 布局結構的主要小部件
      appBar: AppBar(
        title: const Text(
          '單句',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // 主軸對齊方式設置為居中
          children: <Widget>[
            Text('這是單句頁面'),
          ],
        ),
      ),
    );
  }
}