import 'package:flutter/material.dart';

class SingleSentencePage extends StatelessWidget {
  const SingleSentencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold 是一個 Material Design 布局結構的主要小部件
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // 設置頂部背景顏色為主題的主要顏色
        //title: const Text('單句'),
        title: const Text(
          '單句',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // 主軸對齊方式設置為居中
          children: <Widget>[
            const Text('這是單句頁面'),
            const SizedBox(height: 20), // 添加一個高度為20的空間
            ElevatedButton(
              // ElevatedButton 模組，按下時執行導航操作
            onPressed: () {
                Navigator.pop(context); // 當按鈕被按下時返回到上一頁
              },
              child: const Text('返回題庫'), // 按鈕顯示的文字
            ),
          ],
        ),
      ),
    );
  }
}