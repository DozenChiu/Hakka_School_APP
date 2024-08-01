import 'package:flutter/material.dart';
import '../Services/database_helper.dart';
import 'bottom_nav_bar.dart';

class LearningProgressPage extends StatelessWidget {
  LearningProgressPage({super.key});

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        '答題進度',
        style: TextStyle(color: Colors.white),
      )
    ),
    body: Center(
      child: FutureBuilder<List<Test>?>(
        future: dbHelper.getQuestionCount(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
          return const Text('No data found');
          } else {
            final list = snapshot.data!;
            final result = (list[0].correct/list[0].ttl)*100;/// 顯示%數的正確方法?
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('單句測驗進度：${(result).toString()}'),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: LinearProgressIndicator(
                    value: list[0].correct/list[0].ttl,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    //minHeight: 10.0,
                  ),
                ),
                SizedBox(height: 20,),
                Text ('對話理解進度：'),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: LinearProgressIndicator(
                    value: list[1].correct/list[1].ttl,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    //minHeight: 10.0,
                  ),
                ),
                SizedBox(height: 20),
                Text('閱讀測驗進度：'),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: LinearProgressIndicator(
                    value: list[2].correct/list[2].ttl,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    //minHeight: 10.0,
                  ),
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
}