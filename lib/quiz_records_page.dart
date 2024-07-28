import 'package:flutter/material.dart';
import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'bottom_nav_bar.dart';


class QuizRecordPage extends StatefulWidget {
  @override
  _QuizRecordPageState createState() => _QuizRecordPageState();
}

class _QuizRecordPageState extends State<QuizRecordPage> {
  List<Map<String, dynamic>> _quizScores = [];
  Map<int, List<Map<String, dynamic>>> _expandedRecords = {};

  @override
  void initState() {
    super.initState();
    _loadQuizScores();
  }

  Future<void> _loadQuizScores() async {
    final dbPath = join(await databaseFactoryFfi.getDatabasesPath(), 'Quiz.db');
    final database = await databaseFactoryFfi.openDatabase(dbPath);

    final List<Map<String, dynamic>> scores = await database.query('quiz_score', orderBy: 'timestamp DESC');

    setState(() {
      _quizScores = scores;
    });
  }

  Future<void> _loadExpandedRecords(int testId) async {
    final dbPath = join(await databaseFactoryFfi.getDatabasesPath(), 'Quiz.db');
    final database = await databaseFactoryFfi.openDatabase(dbPath);

    final List<Map<String, dynamic>> records = await database.rawQuery('''
      SELECT qr.question_id, qr.user_answer, qr.correct_answer, 
             q.Questions, q.Option_1, q.Option_2, q.Option_3 
      FROM quiz_record qr
      LEFT JOIN (SELECT 'Listen_1' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Listen_1
                 UNION ALL
                 SELECT 'Listen_2' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Listen_2
                 UNION ALL
                 SELECT 'Reading' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Reading) q
      ON qr.question_id = q.No AND qr.table_name = q.Table_Name
      WHERE qr.Test_id = ?
    ''', [testId]);
    // print('Expanded records for Test ID $testId: $records');

    setState(() {
      _expandedRecords[testId] = records;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('測驗紀錄'),
      ),
      body: ListView.builder(
        itemCount: _quizScores.length,
        itemBuilder: (context, index) {
          final quizScore = _quizScores[index];
          final testId = quizScore['id'];
          final score = quizScore['score'];
          final timestamp = quizScore['timestamp'];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              title: Text(
                '測驗 $testId: 得分 $score',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('日期: $timestamp'),
              children: _expandedRecords[testId]?.map((record) {
                final question = record['Questions'] ?? '未知題目';
                final userAnswer = record['user_answer'];
                final correctAnswer = record['correct_answer'];
                final option1 = record['Option_1'];
                final option2 = record['Option_2'];
                final option3 = record['Option_3'];

                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('選項1: $option1'),
                          Text('選項2: $option2'),
                          Text('選項3: $option3'),
                          Text('您的答案: $userAnswer | 正確答案: $correctAnswer'),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey),
                  ],
                );
              })?.toList() ?? [
                ListTile(
                  title: Text('點擊查看詳情'),
                  onTap: () => _loadExpandedRecords(testId),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2), // 底部導航欄
    );
  }
}