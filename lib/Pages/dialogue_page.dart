import 'package:flutter/material.dart';

class DialoguePage extends StatelessWidget {
  const DialoguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '對話',
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('這是對話頁面'),
          ],
        ),
      ),
    );
  }
}