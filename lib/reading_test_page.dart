import 'package:flutter/material.dart';

class ReadingTestPage extends StatelessWidget {
  const ReadingTestPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 構建一個 Scaffold 小部件作為頁面的主要佈局結構
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // 設置頂部背景顏色為主題的主要顏色
        //title: const Text('閱測'),
        title: const Text(
          '閱測',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主軸對齊方式設置為居中
          children: <Widget>[
            const Text('這是閱測頁面'),
            const SizedBox(height: 20), // 添加一個高度為20的空間
            ElevatedButton(
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