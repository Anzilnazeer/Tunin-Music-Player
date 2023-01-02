import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:on_audio_query/on_audio_query.dart';

import 'package:tunin_2/screens/favourite_pages/favourite_button.dart';
import 'package:tunin_2/widgets/get_songs.dart';

import '../../db_functions/db_function/db_favourite.dart';
import '../../widgets/colors.dart';
import '../../widgets/miniplayer/show_mini.dart';

class SongsList extends StatefulWidget {
  const SongsList({
    super.key,
  });

  static List<SongModel> song = [];

  @override
  State<SongsList> createState() => _SongsListState();
}

enum MenuValues {
  favorites,
  playlist,
}

class _SongsListState extends State<SongsList> {
  final _audioQuery = OnAudioQuery();
  bool isFavourite = true;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  @override
  void dispose() {
    GetSongs.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: musiclistNotifier,
      builder: (context, List<SongModel> musiclist, child) => Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          color: const Color.fromARGB(255, 25, 25, 25),
          child: FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
              sortType: SongSortType.DURATION,
              orderType: OrderType.DESC_OR_GREATER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, item) {
              if (item.data == null) {
                return Center(
                    child: Lottie.asset(
                        'assets/lottie/131209-chart-generation.json',
                        height: 10));
              }
              if (item.data!.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Text(
                        'No Songs Found',
                        style: TextStyle(color: ColorsinUse().white),
                      ),
                    ],
                  ),
                );
              }
              SongsList.song = item.data!;
              if (!FavouriteDb.isfavourite) {
                FavouriteDb.isFavourite(item.data!);
              }
              GetSongs.songscopy = item.data!;
              return ListView.builder(
                itemBuilder: ((context, index) => ListTile(
                      leading: QueryArtworkWidget(
                        id: item.data![index].id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(2),
                        size: 50,
                        artworkFit: BoxFit.fill,
                        quality: 100,
                        nullArtworkWidget: Icon(
                          Icons.music_note_rounded,
                          color: ColorsinUse().white,
                        ),
                      ),
                      title: Text(
                        item.data![index].displayNameWOExt,
                        maxLines: 1,
                        style: TextStyle(color: ColorsinUse().white),
                      ),
                      subtitle: Text(
                        '${item.data![index].artist}',
                        style: TextStyle(color: ColorsinUse().white),
                      ),
                      trailing: FavouriteButton(
                        song: item.data![index],
                      ),
                      onTap: () async {
                        GetSongs.audioPlayer.setAudioSource(
                            GetSongs.createSongList(item.data!),
                            initialIndex: index);

                        await ShowMiniPlayer.updateMiniPlayer(
                            songlist: item.data!);

                        await GetSongs.audioPlayer.play();
                      },
                    )),
                itemCount: item.data!.length,
              );
            },
          ),
        ),
      ),
    );
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
        setState(() {});
      }
    }
  }
}
