import 'package:Hakka_School/Services/audioProvider.dart';
import 'package:Hakka_School/Services/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyFavorite extends StatefulWidget {
  const MyFavorite({super.key});

  @override
  MyFavoriteState createState() => MyFavoriteState();
}

class MyFavoriteState extends State<MyFavorite> {
  final dbHelper = DatabaseHelper();
  final imgProvider = ImgProvider();
  final audioProvider = AudioProvider();
  List<Question>? _questions;
  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    final questions = await dbHelper.fetchMyFavorite();
    setState(() {
      _questions = questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // 如果退出頁面，停止音樂
            onPressed: () {
              audioProvider.stopAudio();
              Navigator.pop(context);
            },
          ),
          title: const Text(
        '我的題目',
        style: TextStyle(color: Colors.white),
      )),

      body: _questions == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _questions?.length ?? 0,
              itemBuilder: (context, index) {
              final question = _questions![index];
              int no = question.num;
              List<String> imgPath = ['','','',''];

              for (int i=0; i<4; i++) {
                imgPath[i] = imgProvider.getImagePath(question.table, no,i);
              }

              return FutureBuilder(
                                future: Future.wait(imgPath.map((path) => imgProvider.imageExists(path)).toList()),
                              builder: (context, AsyncSnapshot<List<bool>> imageSnapshots) {
                                    if (!imageSnapshots.hasData) {
                                          return const Center(
                                              child: CircularProgressIndicator());
                                    }
                                    List<bool> hasPic = [false,false,false,false];

                                    for (int i=0; i<4; i++) {
                                      hasPic[i] = imageSnapshots.data![i];
                                    }

                                    return Card(
                                          margin: const EdgeInsets.all(8.0),
                                          child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:
                                                Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                // 題號
                                                Row(
                                                children: [
                                                  Text('No: $no',
                                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                                                  ),
                                                  if (question.table != 'Reading')
                                                  IconButton(
                                                    icon: const Icon(Icons.volume_up_rounded),
                                                      onPressed: () {
                                                        audioProvider.playAudio( question.table,no.toString());
                                                    }),
                                                    IconButton(
                                                      icon: const Icon(Icons.star, color: Colors.yellow,),
                                                      onPressed: () {
                                                        dbHelper.removeFavoriteData(question.table, no);
                                                        refresh();
                                                      },
                                                    )
                                                ]),
                                                const SizedBox(height: 8),
                                                  // 題目圖片或文字
                                                if (hasPic[0])
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 100,
                                                    // 限制題目圖片的高度
                                                    child: Image.asset(
                                                      imgPath[0],
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )
                                                else
                                                  Text(question.text),
                                                  SizedBox(height: 8),
                                                  // 選項圖片或文字
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Expanded(
                                                        child: Card(
                                                          child: Column(
                                                          children: [
                                                            if (hasPic[1])
                                                              Image.asset(
                                                                imgPath[1],
                                                                width: 80,
                                                                // 調整選項圖片的寬度
                                                                height: 80,
                                                                // 調整選項圖片的高度
                                                                fit: BoxFit.contain, // 保持圖片比例
                                                              )
                                                            else
                                                              Text(
                                                                '1. ${question.opt[0]}',// 顯示選項編號
                                                                textAlign: TextAlign.center,
                                                              ),
                                                          ],
                                                        ),
                                                        )
                                                      ),
                                                      Expanded(
                                                        child: Card(


                                                        child: Column(
                                                          children: [
                                                            if (hasPic[2])
                                                              Image.asset(
                                                                imgPath[2],
                                                                width: 80,
                                                                // 調整選項圖片的寬度
                                                                height: 80,
                                                                // 調整選項圖片的高度
                                                                fit: BoxFit.contain, // 保持圖片比例
                                                          )
                                                            else
                                                              Text(
                                                          '2. ${question.opt[1]}',// 顯示選項編號
                                                            textAlign: TextAlign.center,
                                                      ),
                                                      ],
                                                ),
                                                        )
                                    ),
                                                      Expanded(
                                                        child: Card(


                                                      child: Column(
                                                        children: [
                                                          if (hasPic[3])
                                                            Image.asset(
                                                              imgPath[3],
                                                              width: 80,
                                                              // 調整選項圖片的寬度
                                                              height: 80,
                                                              // 調整選項圖片的高度
                                                              fit: BoxFit.contain, // 保持圖片比例
                                                            )
                                                        else
                                                          Text(
                                                      '3. ${question.opt[2]}',// 顯示選項編號
                                                              textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),
                                                      ),
                                                      )
                                                      ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Answer: ${question.ans.toString()}',
                                                  style: const TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight: FontWeight.bold,),
                                                ),
                                                                  ],
                                                            ),
                                                      ),
                                                );
                                          },
                                    );
                              },
           ),
        );
        }
  }
