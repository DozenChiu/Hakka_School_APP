import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyFavorite extends StatelessWidget {
  const MyFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        '我的題目',
        style: TextStyle(color: Colors.white),
      )),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('這是我的題目頁面'),
          ],
        ),
      ),
    );
  }
}
