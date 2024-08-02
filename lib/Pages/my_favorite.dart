import 'package:Hakka_School/Services/audioProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyFavorite extends StatelessWidget {
  MyFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final imgProvider = ImgProvider();
    String path = imgProvider.getImagePath("Listen_1", 1, 3);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        '我的題目',
        style: TextStyle(color: Colors.white),
      )),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (path!='')
            Image.asset(path)
            else
              Text('path error: $path'),
          ],
        ),
      ),
    );
  }
}
