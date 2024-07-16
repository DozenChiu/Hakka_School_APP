import 'package:flutter/material.dart';

class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '詞彙表', // 設置頂部標題文字
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
          children: <Widget>[
            Text('這是詞彙表頁面'),
            SizedBox(height: 20), // 添加一個高度為20的空間
          ],
        ),
      ),
    );
  }
}