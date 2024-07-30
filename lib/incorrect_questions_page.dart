import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'bottom_nav_bar.dart';

class IncorrectQuestionsPage extends StatefulWidget {
  const IncorrectQuestionsPage({Key? key}) : super(key: key);

  @override
  _IncorrectQuestionsPageState createState() => _IncorrectQuestionsPageState();
}

class _IncorrectQuestionsPageState extends State<IncorrectQuestionsPage> {
  List<Map<String, dynamic>> _errors = [];

  @override
  void initState() {
    super.initState();
    _loadErrors();
  }

  Future<void> _loadErrors() async { // 進入頁面第一步
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final dbPath = join(await databaseFactoryFfi.getDatabasesPath(), 'Quiz.db');
    final database = await databaseFactoryFfi.openDatabase(dbPath);

    final errors = await database.rawQuery('''
      SELECT qe.*, q.Questions, q.Option_1, q.Option_2, q.Option_3
      FROM quiz_error qe
      LEFT JOIN (SELECT 'Listen_1' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Listen_1
                 UNION ALL
                 SELECT 'Listen_2' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Listen_2
                 UNION ALL
                 SELECT 'Reading' as Table_Name, No, Questions, Option_1, Option_2, Option_3 FROM Reading) q
      ON qe.question_id = q.No AND qe.table_name = q.Table_Name
      ORDER BY qe.id DESC
    ''');

    setState(() {
      _errors = errors;
    });
  }

  Future<void> _deleteError(int id) async { // 用來刪除錯誤題目
    final dbPath = join(await databaseFactoryFfi.getDatabasesPath(), 'Quiz.db');
    final database = await databaseFactoryFfi.openDatabase(dbPath);

    await database.delete( // 這邊要小心語法
      'quiz_error',
      where: 'id = ?',
      whereArgs: [id],
    );

    await _loadErrors(); // 一定要有這行，因為按下刪除按鈕需要立即頁面重新整理
  }

  String _getImagePath(String tableName, int questionNumber, int optionNumber) { // 確認圖片位置
    return 'assets/Picture/${tableName.toLowerCase().replaceAll('_', '')}_${questionNumber}_$optionNumber.png';
  }

  Future<bool> _imageExists(String path) async { // 檢查圖片是否存在
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
  String _convertTableName(String tableName) { // 用來顯示錯誤題目來自哪個資料表?，類似 map 操作
    switch (tableName) {
      case 'Listen_1':
        return '聽力能力的單句';
      case 'Listen_2':
        return '聽力能力的對話';
      case 'Reading':
        return '閱讀能力的閱測';
      default:
        return tableName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('錯誤題目')),
      body: ListView.builder(
        itemCount: _errors.length,
        itemBuilder: (context, index) {
          final error = _errors[index];
          final tableName = error['table_name'];
          final question = error['Questions'] ?? '未知題目';
          final questionId = error['question_id'];
          final option1 = error['Option_1'];
          final option2 = error['Option_2'];
          final option3 = error['Option_3'];
          final userAnswer = error['user_answer'];
          final correctAnswer = error['correct_answer'];

          final questionImagePath = _getImagePath(tableName, questionId, 0);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              title: Text(
                //'From : $tableName',
                '題目來自於 : ${_convertTableName(tableName)} - 題號: $questionId',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
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
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double textSize = constraints.maxWidth / 20;
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
                  ),
                ],
              ),
              trailing: IconButton( // 刪除按鈕，按了就會刪除該筆資料(錯誤題目)
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteError(error['id']),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2), // 底下的導覽欄
    );
  }

  Widget _buildOption(bool hasPic, String imagePath, String text, int optionNumber, double textSize) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration( // 這邊就只是選項的底色方塊，會隨著頁面一起縮放
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
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
          if (hasPic) // 有圖片則顯示圖片
            SizedBox(
              width: 100,
              height: 100,
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
          if (hasPic) // 有圖片，則要記得顯示選項的數字
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '$optionNumber',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }
}
