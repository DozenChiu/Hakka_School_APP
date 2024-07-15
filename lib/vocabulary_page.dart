import 'package:flutter/material.dart';

class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // 設置頂部背景顏色為主題的主要顏色
        //title: const Text('詞彙表'),
        title: const Text(
          '詞彙表', // 設置頂部標題文字
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
          children: <Widget>[
            const Text('這是詞彙表頁面'),
            const SizedBox(height: 20), // 添加一個高度為20的空間
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);// 當按鈕被按下時返回到上一頁
              },
              child: const Text('返回學習區'), // 按鈕顯示的文字
            ),
          ],
        ),
      ),
    );
  }
}