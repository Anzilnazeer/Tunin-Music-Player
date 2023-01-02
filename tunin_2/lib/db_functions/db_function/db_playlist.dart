
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tunin_2/db_functions/model/audio_player.dart';

import '../../splash_screen.dart';

import 'db_favourite.dart';

class PlaylistDb {
  static ValueNotifier<List<AudioPlayer>> playlistNotifier = ValueNotifier([]);

  static Future<void> playlistAdd(AudioPlayer value) async {
    final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    await playlistdb.add(value);

    playlistNotifier.value.add(value);
    getAllPlaylist();
  }

  static getAllPlaylist() async {
    final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistdb.values);
    playlistNotifier.notifyListeners();
  }

  static playlistDelete(int index) async {
    final playlistdb = Hive.box<AudioPlayer>('playlistDB');
    await playlistdb.deleteAt(index);
    getAllPlaylist();
  }

  bool playlistnameCheck(name) {
    bool result = false;

    for (int i = 0; i < playlistNotifier.value.length; i++) {
      if (playlistNotifier.value[i].name == name) {
        result = true;
      }
      if (result == true) {
        break;
      }
    }
    return result;
  }

  Future<void> appReset(context) async {
    final playlistDb = Hive.box<AudioPlayer>('playlistDB');
    final musicDb = Hive.box<int>('favouriteDB');
    await musicDb.clear();
    await playlistDb.clear();
    FavouriteDb.favouriteSongs.value.clear();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (Route<dynamic> route) => false);
  }
}
