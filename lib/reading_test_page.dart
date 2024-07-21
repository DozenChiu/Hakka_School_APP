import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ReadingTestPage extends StatelessWidget {
  const ReadingTestPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchReadings() async {
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'Quiz.db'); // print('Database path: $path');
    final db = await databaseFactory.openDatabase(path);
    return await db.query('Reading', orderBy: 'No');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '閱測',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchReadings(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final readings = snapshot.data!;
          final color = Colors.blue; // 統一顏色為藍色
          return ListView.builder(
            itemCount: readings.length,
            itemBuilder: (context, index) {
              final reading = readings[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1), // 背景色
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: color, width: 2.0), // 方塊邊框顏色
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q${reading['No']}: ${reading['Questions'] ?? 'No Question'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('1. ${reading['Option_1'] ?? 'N/A'}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color, // 統一按鈕顏色
                            foregroundColor: Colors.white, // 按鈕文字顏色設置為白色
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('2. ${reading['Option_2'] ?? 'N/A'}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color, // 統一按鈕顏色
                            foregroundColor: Colors.white, // 按鈕文字顏色設置為白色
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('3. ${reading['Option_3'] ?? 'N/A'}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color, // 統一按鈕顏色
                            foregroundColor: Colors.white, // 按鈕文字顏色設置為白色
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Answer: ${reading['Answer'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}