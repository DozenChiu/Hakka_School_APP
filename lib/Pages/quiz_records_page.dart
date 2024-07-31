import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
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
             q.Questions, q.Option_1, q.Option_2, q.Option_3, q.Table_Name
      FROM quiz_record qr
      LEFT JOIN (SELECT 'Listen_1' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Listen_1
                 UNION ALL
                 SELECT 'Listen_2' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Listen_2
                 UNION ALL
                 SELECT 'Reading' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Reading) q
      ON qr.question_id = q.No AND qr.table_name = q.Table_Name
      WHERE qr.Test_id = ?
    ''', [testId]);

    setState(() {
      _expandedRecords[testId] = records;
    });
  }

  String _getImagePath(String tableName, int questionNumber, int optionNumber) { // 照片路徑
    return 'assets/Picture/${tableName.toLowerCase().replaceAll('_', '')}_${questionNumber}_$optionNumber.png';
  }

  Future<bool> _imageExists(String path) async { //判斷照片是否存在
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
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
                final tableName = record['Table_Name'];
                final questionId = record['question_id'];

                final questionImagePath = _getImagePath(tableName, questionId, 0);

                return FutureBuilder(
                  future: Future.wait([
                    _imageExists(_getImagePath(tableName, questionId, 1)),
                    _imageExists(_getImagePath(tableName, questionId, 2)),
                    _imageExists(_getImagePath(tableName, questionId, 3)),
                    _imageExists(questionImagePath),
                  ]),
                  builder: (context, AsyncSnapshot<List<bool>> imageSnapshots) {
                    if (!imageSnapshots.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final hasOption1Pic = imageSnapshots.data![0];
                    final hasOption2Pic = imageSnapshots.data![1];
                    final hasOption3Pic = imageSnapshots.data![2];
                    final hasQuestionPic = imageSnapshots.data![3];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasQuestionPic) // 如果有圖片
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: Image.asset(
                                  questionImagePath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                question,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          // Display options with numbers
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double textSize = constraints.maxWidth / 20; // Adjust size as needed
                              return Row(
                                children: [
                                  if (option1 != null)
                                    Expanded(
                                      child: _buildOption(
                                        hasOption1Pic,
                                        _getImagePath(tableName, questionId, 1),
                                        '1. $option1',
                                        1,
                                        textSize,
                                      ),
                                    ),
                                  if (option2 != null)
                                    Expanded(
                                      child: _buildOption(
                                        hasOption2Pic,
                                        _getImagePath(tableName, questionId, 2),
                                        '2. $option2',
                                        2,
                                        textSize,
                                      ),
                                    ),
                                  if (option3 != null)
                                    Expanded(
                                      child: _buildOption(
                                        hasOption3Pic,
                                        _getImagePath(tableName, questionId, 3),
                                        '3. $option3',
                                        3,
                                        textSize,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          Text(
                            '您的答案: $userAnswer',
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text(
                            '正確答案: $correctAnswer',
                            style: TextStyle(color: Colors.red),
                          ),
                          Divider(color: Colors.grey),
                        ],
                      ),
                    );
                  },
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

  Widget _buildOption(bool hasPic, String imagePath, String text, int optionNumber, double textSize) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(8.0), // 增加 padding
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(8.0), // 調圓角
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (hasPic) // 如有圖片
            SizedBox(
              width: 100,  // 圖片的寬度
              height: 100, // 圖片的高度
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          if (!hasPic)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          if (hasPic)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '$optionNumber',
                style: TextStyle(fontSize: 14, color: Colors.black87), // 選項圖片的數字
              ),
            ),
        ],
      ),
    );
  }
}