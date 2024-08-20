import 'package:Hakka_School/Services/database_helper.dart';
import 'package:flutter/material.dart';

class ReadingTestPage extends StatefulWidget {
  const ReadingTestPage({super.key});

  @override
  ReadingTestState createState() => ReadingTestState();
}

class ReadingTestState extends State<ReadingTestPage> {
  final dbHelper = DatabaseHelper();
  List<Question>? _reading;
  var hakkaText = const TextStyle(
      fontFamily: 'forHakka',
      fontSize: 16);

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    final reading = await dbHelper.fetchQuestion('Reading');
    setState(() {
      _reading = reading;
    });
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
      body: _reading==null?const Center(child: CircularProgressIndicator())
          :ListView.builder(
            itemCount: _reading?.length??0,
            itemBuilder: (context, index) {
              final reading = _reading![index];
              final no = reading.num;
              final table = reading.table;
              return Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                Text('No: $no',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                        IconButton(
                          icon: Icon(reading.isFavorite? Icons.star:Icons.star_border,
                              color: Colors.yellow),
                          onPressed: () async {
                            if (reading.isFavorite) {
                              await dbHelper.removeFavoriteData(table, no);
                            } else {
                              await dbHelper.insertFavorite(table, no);
                            }
                            refresh();
                          },)
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    Text(reading.text,
                      style: hakkaText,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Card(
                            child: Text('1. ${reading.opt[0]}',style: hakkaText, textAlign: TextAlign.center,),
                          ),
                        ),
                        Expanded(
                          child: Card(
                          child: Text('2. ${reading.opt[1]}',style: hakkaText, textAlign: TextAlign.center,),
                        ),
                        ),
                        Expanded(
                            child: Card(
                          child: Text('3. ${reading.opt[2]}',style: hakkaText, textAlign: TextAlign.center,),
                        ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Answer：${reading.ans}. ${reading.opt[reading.ans-1]}',
                      style: const TextStyle(
                        fontFamily: 'forHakka',
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              )
              );
        },
      ),
    );
  }
}
