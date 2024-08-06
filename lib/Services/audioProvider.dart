import 'dart:io';

import 'package:audioplayers/audioplayers.dart';

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
  String getImagePath(String table, int no, int option) {
    if (table == "Reading") return "";
    table = table=="Listen_1" ? "listen1" : "listen2";
    String path = 'assets/Picture/${table}_${no}_$option.png';
    return path;
  }

  Future<bool> imageExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

}