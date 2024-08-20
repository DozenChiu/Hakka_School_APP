import 'package:flutter/material.dart';
import '../Services/database_helper.dart';
import 'bottom_nav_bar.dart';

class LearningProgressPage extends StatelessWidget {
  LearningProgressPage({super.key});

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          double fontSize = ((constraints.maxWidth/30)<24)?24:(constraints.maxWidth/30); // 設定字體根據寬度調整，保留最小大小
          double paddingHeight = constraints.maxHeight/20; // 設定 SizedBox 根據高度調整
          return Scaffold(
            appBar: AppBar(
                title: const Text(
                  '答題進度',
                  style: TextStyle(color: Colors.white),
                )),
            body: Center(
              child: FutureBuilder<List<Progress>?>(
                future: dbHelper.getQuestionCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data found');
                  } else {
                    final list = snapshot.data!;
                    List<double> result = [0,0,0]; // 計算每種測驗的進度
                    for (int i=0; i<3; i++) {
                      result[i] = list[i].correct / list[1].ttl;
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.all(16.0),
                            width: constraints.maxWidth*(1/3),
                            height: constraints.maxHeight/6,
                            child: Column(
                                children: [
                                  Text('單句測驗：${(result[0]*100).toStringAsFixed(2)}%',
                                    style: TextStyle(fontSize: fontSize*0.6, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: paddingHeight*0.5),
                                  LinearProgressIndicator(
                                    value: result[0],
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                    minHeight: paddingHeight*0.5,
                                  ),
                                ]
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.all(16.0),
                            width: constraints.maxWidth*(1/3),
                            height: constraints.maxHeight/6,
                            child: Column(
                                children: [
                                  Text('對話理解：${(result[1]*100).toStringAsFixed(2)}%',
                                    style: TextStyle(fontSize: fontSize*0.6, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: paddingHeight*0.5),
                                  LinearProgressIndicator(
                                    value: result[1],
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                    minHeight: paddingHeight*0.5,
                                  ),
                                ]
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.all(16.0),
                            width: constraints.maxWidth*(1/3),
                            height: constraints.maxHeight/6,
                            child: Column(
                                children: [
                                  Text('閱讀測驗：${(result[2]*100).toStringAsFixed(2)}%',
                                    style: TextStyle(fontSize: fontSize*0.6, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: paddingHeight*0.5),
                                  LinearProgressIndicator(
                                    value: result[2],
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                    minHeight: paddingHeight*0.5,
                                  ),
                                ]
                            )
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            bottomNavigationBar: const BottomNavBar(selectedIndex: 3), // 底部導航欄
          );
        }
    );

  }
}
