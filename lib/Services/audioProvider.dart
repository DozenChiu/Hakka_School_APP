import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle; // 讀取圖片方式的套件

class AudioProvider {
  final _player = AudioPlayer();
  bool isPlaying = false;

  Future<void> playAudio(String table,String index) async {
    if (table == 'Listen_1') {
      table = 'Lis_01';
      index = '01_$index';
    }
    else {
      table = 'Lis_02';
      index = '02_$index';
    }
    final String path = 'Sound/$table/$index.mp3';
    if (isPlaying) {
      await _player.stop();
    }
    await _player.play(AssetSource(path));
    isPlaying = true;
  }

  void stopAudio() {
    if (isPlaying) {
      _player.stop();
      isPlaying = false;
    }
  }
}

class ImgProvider {
  Future<bool> imageExists(String path) async {
    try {
      final byteData = await rootBundle.load(path);
      return byteData.lengthInBytes > 0;
    } catch (e) {
      return false;
    }
  }
  String getImagePath(String table, int no, int option) {
    if (table == "Reading") return "";
    table = table == "Listen_1" ? "listen1" : "listen2";
    return 'assets/Picture/${table}_${no}_$option.png';
  }
}