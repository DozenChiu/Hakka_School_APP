import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class AudioProvider with ChangeNotifier{
  final _player = AudioPlayer();
  bool isPlaying = false;

  Future<void> playAudio(String table,String index) async {
    table = table=='Listen_1' ? 'Lis_01':'Lis_02';
    final String path = 'Sound/$table/$index.mp3';
    if (isPlaying) {
      await _player.stop();
    }
    await _player.play(AssetSource(path));
    isPlaying = true;
    notifyListeners();
  }

  void stopAudio() {
    if (isPlaying) {
      _player.stop();
      isPlaying = false;
      notifyListeners();
    }
  }
}