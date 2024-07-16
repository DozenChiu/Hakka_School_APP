import 'package:flutter/material.dart';

class ReadingTestPage extends StatelessWidget {
  const ReadingTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 構建一個 Scaffold 小部件作為頁面的主要佈局結構
      appBar: AppBar(
        title: const Text(
          '閱測',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
          children: <Widget>[
            Text('這是閱測頁面'),
          ],
        ),
      ),
    );
  }
}