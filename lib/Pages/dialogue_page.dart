import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

class DialoguePage extends StatelessWidget {
  const DialoguePage({super.key});

  Future<List<Map<String, dynamic>>> _fetchDialogues() async {
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'Quiz.db');
    // print('Database path: $path');
    final db = await databaseFactory.openDatabase(path);
    return await db.query('Listen_2', orderBy: 'No');
  }

  String _getImagePath(int no, int option) {
    return 'assets/Picture/listen2_${no}_${option}.png';
  }

  Future<bool> _imageExists(String path) async {
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
        title: const Text(
          '對話',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchDialogues(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dialogues = snapshot.data!;
          return ListView.builder(
            itemCount: dialogues.length,
            itemBuilder: (context, index) {
              final dialogue = dialogues[index];
              final no = dialogue['No'] as int;
              final hasPic = dialogue['HasPic'] as int;

              final option1ImagePath = _getImagePath(no, 1);
              final option2ImagePath = _getImagePath(no, 2);
              final option3ImagePath = _getImagePath(no, 3);
              final questionImagePath = _getImagePath(no, 0);

              return FutureBuilder(
                future: Future.wait([
                  _imageExists(option1ImagePath),
                  _imageExists(option2ImagePath),
                  _imageExists(option3ImagePath),
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
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 題號
                          Text(
                            'No: $no',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),

                          // 題目圖片或文字
                          if (hasQuestionPic)
                            SizedBox(
                              width: double.infinity,
                              height: 100, // 限制題目圖片的高度
                              child: Image.asset(
                                questionImagePath,
                                fit: BoxFit.contain,
                              ),
                            )
                          else
                            Text(dialogue['Questions'] ?? 'No Question'),

                          SizedBox(height: 8),

                          // 選項圖片或文字
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (dialogue['Option_1'] != null)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Column(
                                      children: [
                                        if (hasOption1Pic)
                                          Image.asset(
                                            option1ImagePath,
                                            width: 80, // 調整選項圖片的寬度
                                            height: 80, // 調整選項圖片的高度
                                            fit: BoxFit.contain, // 保持圖片比例
                                          )
                                        else
                                          Text(
                                            '1. ${dialogue['Option_1'] ?? 'N/A'}',
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (dialogue['Option_2'] != null)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Column(
                                      children: [
                                        if (hasOption2Pic)
                                          Image.asset(
                                            option2ImagePath,
                                            width: 80, // 調整選項圖片的寬度
                                            height: 80, // 調整選項圖片的高度
                                            fit: BoxFit.contain, // 保持圖片比例
                                          )
                                        else
                                          Text(
                                            '2. ${dialogue['Option_2'] ?? 'N/A'}',
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (dialogue['Option_3'] != null)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Column(
                                      children: [
                                        if (hasOption3Pic)
                                          Image.asset(
                                            option3ImagePath,
                                            width: 80, // 調整選項圖片的寬度
                                            height: 80, // 調整選項圖片的高度
                                            fit: BoxFit.contain, // 保持圖片比例
                                          )
                                        else
                                          Text(
                                            '3. ${dialogue['Option_3'] ?? 'N/A'}',
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8),

                          Text(
                            'Answer: ${dialogue['Answer'] ?? 'N/A'}',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
