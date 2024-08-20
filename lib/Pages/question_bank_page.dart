import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'dialogue_page.dart';
import 'reading_test_page.dart';
import 'single_sentence_page.dart';

class QuestionBankPage extends StatelessWidget {
  const QuestionBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          double fontSize = ((constraints.maxWidth/30)<24)?24:(constraints.maxWidth/30); // 設定字體根據寬度調整，保留最小大小
          double paddingHeight = constraints.maxHeight/20; // 設定 SizedBox 根據高度調整
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                '題庫',
                style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '聽力能力',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: paddingHeight), // 添加一個高度為20的空間
                    ElevatedButton.icon(
                      icon: Icon(Icons.hearing, size: fontSize*0.6,), // 設置按鈕左側的圖標
                      label: Text('單句', // 設置按鈕文字
                          style: TextStyle(fontSize: fontSize*0.6)
                      ),
                      onPressed: () {
                        // 當按鈕被按下時導航到單句頁面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SingleSentencePage()),
                        );
                      },
                    ),
                    SizedBox(height: paddingHeight), // 添加一個高度為10的空間
                    ElevatedButton.icon(
                      icon: Icon(Icons.hearing, size: fontSize*0.6,), // 設置按鈕左側的圖標
                      label: Text('對話',
                        style: TextStyle(fontSize: fontSize*0.6),
                      ), // 設置按鈕文字
                      onPressed: () {
                        // 當按鈕被按下時導航到對話頁面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const DialoguePage()), // 創建導航到 DialoguePage 頁面
                        );
                      },
                    ),

                    SizedBox(height: paddingHeight), // 添加一個高度為40的空間，分隔不同類別
                    Text(
                      '閱讀能力',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: paddingHeight), // 添加一個高度為20的空間
                    ElevatedButton.icon(
                      icon: Icon(Icons.book, size: fontSize*0.6,), // 設置按鈕左側的圖標
                      label: Text('閱測',
                        style: TextStyle( fontSize: fontSize*0.6),
                      ), // 設置按鈕文字
                      onPressed: () {
                        // 當按鈕被按下時導航到閱測頁面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReadingTestPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const BottomNavBar(selectedIndex: 1), // 底部導航欄
          );
        }
    );
  }
}
