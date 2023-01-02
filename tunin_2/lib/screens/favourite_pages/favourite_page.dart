import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunin_2/db_functions/db_function/db_favourite.dart';

import 'package:tunin_2/widgets/colors.dart';

import '../../widgets/get_songs.dart';
import '../../widgets/miniplayer/show_mini.dart';

class FavoratePage extends StatefulWidget {
  const FavoratePage({super.key});

  @override
  State<FavoratePage> createState() => _FavoratePageState();
}

ConcatenatingAudioSource createSongList(List<SongModel> song) {
  List<AudioSource> source = [];
  for (var songs in song) {
    source.add(AudioSource.uri(Uri.parse(songs.uri!)));
  }
  return ConcatenatingAudioSource(children: source);
}

class _FavoratePageState extends State<FavoratePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavouriteDb.favouriteSongs,
      builder:
          (BuildContext context, List<SongModel> favourData, Widget? child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: FadeScrollAppBar(
              scrollController: _scrollController,
              pinned: false,
              elevation: 5,
              fadeOffset: 100,
              expandedHeight: 140,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              fadeWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Liked Songs",
                          style: TextStyle(
                            color: ColorsinUse().white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              child: ValueListenableBuilder(
                  valueListenable: FavouriteDb.favouriteSongs,
                  builder:
                      (context, List<SongModel> favourData, Widget? child) {
                    return FavouriteDb.favouriteSongs.value.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                Lottie.asset(
                                    'assets/lottie/58790-favourite-animation.json',
                                    height: 250),
                                Text(
                                  'No Favourites',
                                  style: TextStyle(
                                      color: ColorsinUse().white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ValueListenableBuilder(
                                valueListenable: FavouriteDb.favouriteSongs,
                                builder: (BuildContext context,
                                    List<SongModel> favorData, Widget? child) {
                                  return ListView.builder(
                                    itemCount: favorData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        onTap: () {
                                          FavouriteDb.favouriteSongs
                                              .notifyListeners();
                                          List<SongModel> favourlist = [
                                            ...favorData
                                          ];

                                          GetSongs.audioPlayer.setAudioSource(
                                              GetSongs.createSongList(
                                                  favourlist),
                                              initialIndex: index);

                                          GetSongs.audioPlayer.play();

                                          ShowMiniPlayer.updateMiniPlayer(
                                              songlist: favourlist);
                                        },
                                        tileColor: const Color.fromARGB(
                                            39, 126, 126, 126),
                                        leading: QueryArtworkWidget(
                                          artworkBorder:
                                              BorderRadius.circular(5),
                                          id: favorData[index].id,
                                          type: ArtworkType.AUDIO,
                                          nullArtworkWidget: const Icon(
                                            Icons.music_note_rounded,
                                            color: Color.fromARGB(
                                                137, 255, 255, 255),
                                            size: 52,
                                          ),
                                        ),
                                        title: Text(
                                          favorData[index].title,
                                          maxLines: 1,
                                        ),
                                        subtitle:
                                            Text(favorData[index].artist!),
                                        trailing: IconButton(
                                          onPressed: () {
                                            FavouriteDb.favouriteSongs
                                                .notifyListeners();
                                            FavouriteDb.delete(
                                                favorData[index].id);
                                          },
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Color.fromARGB(
                                                255, 202, 42, 30),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          );
                  }),
            ),
          ),
        );
      },
    );
  }
}
