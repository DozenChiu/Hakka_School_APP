import 'package:Hakka_School/Services/database_helper.dart';
import 'package:flutter/material.dart';
import '../Services/audioProvider.dart';

class SingleSentencePage extends StatefulWidget {
  const SingleSentencePage({super.key});

  @override
  SingleSentenceState createState() => SingleSentenceState();
}

class SingleSentenceState extends State<SingleSentencePage> {
  final dbHelper = DatabaseHelper();
  final imgProvider = ImgProvider();
  final audioProvider = AudioProvider();
  List<Question>? _listening;


  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    final listening = await dbHelper.fetchQuestion('Listen_1');
    setState(() {
      _listening = listening;
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
          '單句',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _listening==null?const Center(child: CircularProgressIndicator())
          :ListView.builder(
          itemCount: _listening?.length ?? 0,
          itemBuilder: (context, index) {
              final listening_1 = _listening![index];
              final no = listening_1.num;
              final table = listening_1.table;
              List<String> imgPath = ['','','',''];

              for (int i=0; i<4; i++) {
                imgPath[i] = imgProvider.getImagePath(table, no,i);
              }

              return FutureBuilder(
                future: Future.wait(imgPath.map((path) => imgProvider.imageExists(path)).toList()),
                builder: (context, AsyncSnapshot<List<bool>> imageSnapshots) {
                  if (!imageSnapshots.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<bool> hasPic = [false,false,false,false];

                  for (int i=0; i<4; i++) {
                    hasPic[i] = imageSnapshots.data![i];
                  }

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 題號
                          Row(
                          children: [
                            Text(
                              'No: $no',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.volume_up_rounded),
                                onPressed: () {
                                  audioProvider.playAudio(table, no.toString());
                                }),

                              IconButton(
                              icon: Icon(listening_1.isFavorite? Icons.star:Icons.star_border,
                                color: Colors.yellow,
                              ),
                              onPressed: () async {
                                if (listening_1.isFavorite) {
                                  await dbHelper.removeFavoriteData(table, no);
                                } else {
                                  await dbHelper.insertFavorite(table, no);
                                }
                                refresh();
                              },)
                          ]),

                          const SizedBox(height: 8),
                          // 題目圖片或文字
                          if (hasPic[0])
                            SizedBox(
                              width: double.infinity,
                              height: 100, // 限制題目圖片的高度
                              child: Image.asset(
                                imgPath[0],
                                fit: BoxFit.contain,
                              ),
                            )
                          else
                            Text(listening_1.text),

                          const SizedBox(height: 8),

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
                                            width: 80, // 調整選項圖片的寬度
                                            height: 80, // 調整選項圖片的高度
                                            fit: BoxFit.contain, // 保持圖片比例
                                          )
                                        else
                                          Text(
                                            '1. ${listening_1.opt[0]}', // 顯示選項編號
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                ),
                                ),
                                Expanded(
                                  child: Card(
                                    child: Column(
                                      children: [
                                        if (hasPic[2])
                                          Image.asset(
                                            imgPath[2],
                                            width: 80, // 調整選項圖片的寬度
                                            height: 80, // 調整選項圖片的高度
                                            fit: BoxFit.contain, // 保持圖片比例
                                          )
                                        else
                                          Text(
                                            '2. ${listening_1.opt[1]}', // 顯示選項編號
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    child: Column(
                                      children: [
                                        if (hasPic[3])
                                          Image.asset(
                                            imgPath[3],
                                            width: 80, // 調整選項圖片的寬度
                                            height: 80, // 調整選項圖片的高度
                                            fit: BoxFit.contain, // 保持圖片比例
                                          )
                                        else
                                          Text(
                                            '3. ${listening_1.opt[2]}', // 顯示選項編號
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Text(
                            'Answer: ${listening_1.ans}',
                            style: const TextStyle(
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
          )
    );
  }
}
