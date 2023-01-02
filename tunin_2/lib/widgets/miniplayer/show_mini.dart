import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunin_2/screens/home_oage/now_playing_page.dart';

class ShowMiniPlayer {


  static updateMiniPlayer({required List<SongModel> songlist}) {
    playingSongNotifier.value.clear();
    playingSongNotifier.value.addAll(songlist);
    playingSongNotifier.notifyListeners();
  }
}
