import 'package:flutter/material.dart';
import '../Services/audioProvider.dart';
import 'package:Hakka_School/Services/database_helper.dart';

class DialoguePage extends StatefulWidget {
  const DialoguePage({super.key});

  @override
  DialogueState createState() => DialogueState();
}


class DialogueState extends State<DialoguePage> {
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
    final listening = await dbHelper.fetchQuestion('Listen_2');
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
          '對話',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _listening==null?const Center(child: CircularProgressIndicator())
        :ListView.builder(
        itemCount: _listening?.length ?? 0,
        itemBuilder: (context, index) {
        final listening_2 = _listening![index];
        final no = listening_2.num;
        final table = listening_2.table;

              List<String> imgPath = ['','','',''];
              for (int i=0; i<4; i++) {
                imgPath[i] = imgProvider.getImagePath('Listen_2', no,i);
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
                          Row(children: [
                            Text(
                              'No: $no',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.volume_up_rounded),
                                onPressed: (){
                                  audioProvider.playAudio(
                                      'Listen_2', no.toString());
                                }),
                            IconButton(
                              icon: Icon(listening_2.isFavorite? Icons.star:Icons.star_border,
                                  color: Colors.yellow
                              ),
                              onPressed: () async {
                                if (listening_2.isFavorite) {
                                  await dbHelper.removeFavoriteData(table, no);
                                } else {
                                  await dbHelper.insertFavorite(table, no);
                                }
                                refresh();
                              },
                            )
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
                            Text(listening_2.text),

                          const SizedBox(height: 8),

                          // 選項圖片或文字
                          Row(
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
                                            '1. ${listening_2.opt[0]}',
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
                                            '2. ${listening_2.opt[1]}',
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
                                            '3. ${listening_2.opt[2]}',
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
                            'Answer: ${listening_2.ans}',
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
      ),
    );
  }
}
