import 'package:flutter/material.dart';
import 'package:case1/Services/database_service.dart';

class VocabularyPage extends StatefulWidget {

  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPage();
}

class _VocabularyPage extends State<VocabularyPage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '詞彙表', // 設置頂部標題文字
          style: TextStyle(color: Colors.white), // 設置標題文字顏色為白色
        ),
      ),
      body: _wordlist(),

    );
  }

  Widget _wordlist() {
    return FutureBuilder<List<Wordlist>?>(
      future: _databaseService.getWordlist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Data'));
        } else {
          final wordlist = snapshot.data!;
          return ListView.builder(
            itemCount: wordlist.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(wordlist[index].word),
              );
            },
          );
        }
      },
    );
  }
}
