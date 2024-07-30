import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'bottom_nav_bar.dart';
import 'dart:async';
import 'quiz_records_page.dart';
import 'dart:io';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Database _database;
  List<Map<String, dynamic>> _questions = []; // 存放挑選的問題
  Map<int, int?> _answers = {}; // 存答題人的選擇答案
  Timer? _timer; // 時間函數宣告
  int _remainingTime = 15 * 60; // 15分鐘倒計時，單位為秒

  @override
  void initState() { // 一開始進入頁面要做的事
    super.initState();
    _initializeDatabase();
    _startTimer(); // 開始倒數計時
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeDatabase() async { //載入測驗區頁面需要先初始化資料庫
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Quiz.db');
    _database = await openDatabase(path);
    await _fetchQuestions();
  }

  Future<void> _fetchQuestions() async { // 挑選問題
    _answers.clear(); // 清空答題人的選項
    // 單句隨機挑選 10 題
    List<Map<String, dynamic>> listen1Questions = await _database.rawQuery(
        'SELECT *, "Listen_1" as Table_Name FROM Listen_1 ORDER BY RANDOM() LIMIT 10'
    );
    // 對話隨機挑選 5 題
    List<Map<String, dynamic>> listen2Questions = await _database.rawQuery(
        'SELECT *, "Listen_2" as Table_Name FROM Listen_2 ORDER BY RANDOM() LIMIT 5'
    );
    // 閱測隨機挑選 10 題
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

  void _startTimer() { // 計時動作
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

  String _formatTime(int seconds) { // 顯示時間格式
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _submitAnswers() async {
    int correctAnswers = 0;

    final lastTestIdResult = await _database.rawQuery('SELECT MAX(id) AS lastTestId FROM quiz_score');
    int newTestId = (lastTestIdResult.first['lastTestId'] as int? ?? 0) + 1;

    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final correctAnswer = question['Answer'];
      final userAnswer = _answers[question['No']] ?? -1;

      if (userAnswer == correctAnswer) {
        // 比對答案，判斷是否正確
        correctAnswers++;
      } else {
        // 如果有錯則寫進資料庫 quiz_error，其內容之後顯示於錯誤題目頁面
        await _database.insert('quiz_error', {
          'table_name': question['Table_Name'],
          'question_id': question['No'],
          'user_answer': userAnswer,
          'correct_answer': correctAnswer,
        });
      }
      // 把題目相關東西寫進資料庫 quiz_record，用於測驗紀錄頁面
      await _database.insert('quiz_record', {
        'table_name': question['Table_Name'],
        'question_id': question['No'],
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'Test_id': newTestId,
      });
    }
    // 計算成績
    final score = (correctAnswers / _questions.length) * 100;
    // 把成績和考試時間寫進資料庫 quiz_score
    await _database.insert('quiz_score', {
      'id': newTestId,
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

  String _convertTableName(String tableName) { // 資料庫比對照片名稱，需要做對應
    return tableName.replaceAll('_', '').toLowerCase();
  }

  String _getImagePath(String tableName, int questionNumber, int optionNumber) {
    final convertedTableName = _convertTableName(tableName);
    final path = 'assets/Picture/${convertedTableName}_${questionNumber}_$optionNumber.png';
    // print('Generated image path: $path'); // For debugging
    return path;
  }

  Future<bool> _imageExists(String path) async { // 判斷題目or選項，是否有對應圖片
    try {
      final file = File(path);
      final exists = await file.exists();
      // print('Checking $path: $exists'); // For debugging
      return exists;
    } catch (e) {
      // print('Error checking $path: $e'); // For debugging
      return false;
    }
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
          final questionImagePath = _getImagePath(question['Table_Name'], question['No'], 0);

          return FutureBuilder(
            future: Future.wait([
              _imageExists(_getImagePath(question['Table_Name'], question['No'], 1)),
              _imageExists(_getImagePath(question['Table_Name'], question['No'], 2)),
              _imageExists(_getImagePath(question['Table_Name'], question['No'], 3)),
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

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 如果題目有圖片
                      if (hasQuestionPic)
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Image.asset(
                            questionImagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      // 題目圖片與題目文字之間留出空隙
                      if (hasQuestionPic)
                        SizedBox(height: 16),
                      // 顯示題目文字
                      Text(
                        '${index + 1}. ${question['Questions']}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (question['Option_1'] != null)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _answers[question['No']] = 1;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('1. '),
                                        if (hasOption1Pic)
                                          Image.asset(
                                            _getImagePath(question['Table_Name'], question['No'], 1),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          )
                                        else
                                          Text(
                                            ' ${question['Option_1']}',
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _answers[question['No']] == 1
                                      ? Colors.orange
                                      : null,
                                ),
                              ),
                            ),
                          if (question['Option_2'] != null)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _answers[question['No']] = 2;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('2. '),
                                        if (hasOption2Pic)
                                          Image.asset(
                                            _getImagePath(question['Table_Name'], question['No'], 2),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          )
                                        else
                                          Text(
                                            ' ${question['Option_2']}',
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _answers[question['No']] == 2
                                      ? Colors.orange
                                      : null,
                                ),
                              ),
                            ),
                          if (question['Option_3'] != null)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _answers[question['No']] = 3;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('3. '),
                                        if (hasOption3Pic)
                                          Image.asset(
                                            _getImagePath(question['Table_Name'], question['No'], 3),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          )
                                        else
                                          Text(
                                            ' ${question['Option_3']}',
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _answers[question['No']] == 3
                                      ? Colors.orange
                                      : null,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2), // 底部導航欄
      floatingActionButton: FloatingActionButton(
        onPressed: _submitAnswers,
        child: Center(
          child: Text(
            '提交',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // 設置文字顏色
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}