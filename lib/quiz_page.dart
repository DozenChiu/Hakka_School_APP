import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'bottom_nav_bar.dart';
import 'dart:async';
import 'quiz_records_page.dart';


class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Database _database;
  List<Map<String, dynamic>> _questions = [];
  Map<int, int?> _answers = {}; // 存答題的人選擇的答案
  Timer? _timer;
  int _remainingTime = 15 * 60; // 15分鐘倒計時，單位為秒

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _startTimer(); // 開始時間
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeDatabase() async { // 載入測驗區要先初始化
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Quiz.db');
    _database = await openDatabase(path);
    await _fetchQuestions(); // 抓問題
  }

  Future<void> _fetchQuestions() async {

    _answers.clear(); // 一定要先清空答題人的選項
    // 挑題目，總共20題
    List<Map<String, dynamic>> listen1Questions = await _database.rawQuery(
        'SELECT *, "Listen_1" as Table_Name FROM Listen_1 ORDER BY RANDOM() LIMIT 10'
    );
    List<Map<String, dynamic>> listen2Questions = await _database.rawQuery(
        'SELECT *, "Listen_2" as Table_Name FROM Listen_2 ORDER BY RANDOM() LIMIT 5'
    );
    List<Map<String, dynamic>> readingQuestions = await _database.rawQuery(
        'SELECT *, "Reading" as Table_Name FROM Reading ORDER BY RANDOM() LIMIT 10'
    );

    setState(() {
      _questions = [
        ...listen1Questions,
        ...listen2Questions,
        ...readingQuestions
      ];
      // 初始化 _answers Map
      for (var question in _questions) {
        _answers[question['No']] = null;
      }
    });
  }
  // 倒數計時功能
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _submitAnswers();
        }
      });
    });
  }
  // 顯示時間格式
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _submitAnswers() async {
    int correctAnswers = 0;

    // 獲取最新的 Test_id
    final lastTestIdResult = await _database.rawQuery('SELECT MAX(id) AS lastTestId FROM quiz_score');
    int newTestId = (lastTestIdResult.first['lastTestId'] as int? ?? 0) + 1;

    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final correctAnswer = question['Answer'];
      final userAnswer = _answers[question['No']] ?? -1; // 如果沒有回答，先暫時設定為 -1
      //print('Question ${question['No']} - User Answer: $userAnswer, Correct Answer: $correctAnswer');

      // 計算正確題數
      if (userAnswer == correctAnswer) {
        correctAnswers++;
      } else {
        // 答錯的情況，將題目寫入 quiz_error 資料表中
        await _database.insert('quiz_error', {
          'table_name': question['Table_Name'],
          'question_id': question['No'],
          'user_answer': userAnswer,
          'correct_answer': correctAnswer,
        });
      }
      // 測驗題目寫進 quiz_record 資料表
      await _database.insert('quiz_record', {
        'table_name': question['Table_Name'],
        'question_id': question['No'],
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'Test_id': newTestId, // 使用新的 Test_id
      });
    }
    // 算分數
    final score = (correctAnswers / _questions.length) * 100;
    // 紀錄分數
    await _database.insert('quiz_score', {
      'id': newTestId, // 使用新的 Test_id
      'score': score,
      'timestamp': DateTime.now().toIso8601String(),
    });

    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        title: Text('測驗結果'),
        content: Text('你答對了 $correctAnswers 題，得分為 $score 分。'),
        actions: <Widget>[
          TextButton(
            child: Text('確定'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => QuizRecordPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('測驗'),
            SizedBox(width: 20),
            Text(
              '倒數計時',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 8),
            Text(
              _formatTime(_remainingTime),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: _questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${question['Questions']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  for (int i = 1; i <= 3; i++)
                    RadioListTile<int>(
                      title: Text(question['Option_$i']),
                      value: i,
                      groupValue: _answers[question['No']],
                      onChanged: (value) {
                        setState(() {
                          _answers[question['No']] = value;
                        });
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2), // 底部導航欄
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitAnswers,
          child: Text('提交'),
        ),
      ),
    );
  }
}