import 'package:flutter/material.dart';

class SingleSentencePage extends StatelessWidget {
  const SingleSentencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('這是單句頁面'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('返回題庫'),
            ),
          ],
        ),
      ),
    );
  }
}