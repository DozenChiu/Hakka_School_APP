import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
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

  Future<void> _loadErrors() async {
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

  Future<void> _deleteError(int id) async {
    final dbPath = join(await databaseFactoryFfi.getDatabasesPath(), 'Quiz.db');
    final database = await databaseFactoryFfi.openDatabase(dbPath);

    await database.delete(
      'quiz_error',
      where: 'id = ?',
      whereArgs: [id],
    );

    // 刪除操作完成後重新加載錯誤列表
    await _loadErrors();
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
          final option1 = error['Option_1'];
          final option2 = error['Option_2'];
          final option3 = error['Option_3'];
          final userAnswer = error['user_answer'];
          final correctAnswer = error['correct_answer'];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                'From : $tableName',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question),
                  SizedBox(height: 8),
                  Text('選項1: $option1'),
                  Text('選項2: $option2'),
                  Text('選項3: $option3'),
                  SizedBox(height: 8),
                  Text('您的答案: $userAnswer | 正確答案: $correctAnswer'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteError(error['id']),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2), // 底部導航欄
    );
  }
}