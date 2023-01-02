import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunin_2/widgets/get_songs.dart';
import 'package:tunin_2/screens/home_oage/songs_list.dart';

import '../../widgets/colors.dart';
import 'now_playing_page.dart';

class Serach extends StatefulWidget {
  const Serach({super.key});

  @override
  State<Serach> createState() => _SerachState();
}

class _SerachState extends State<Serach> {
  List<SongModel> findSongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ListView(children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 18),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Text(
                'Search songs',
                style: TextStyle(
                  color: Color.fromARGB(220, 255, 255, 255),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: ColorsinUse().red,
              autofocus: true,
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) => runFilter(value),
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none),
                  fillColor: const Color.fromARGB(47, 255, 255, 255),
                  suffixIcon: Icon(
                    Icons.search,
                    color: ColorsinUse().red,
                  ),
                  hintText: 'search songs here..',
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(148, 255, 255, 255))),
            ),
          ),
          SingleChildScrollView(
              child: ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: ((context, index) {
              return ListTile(
                leading: QueryArtworkWidget(
                  id: findSongs[index].id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(2),
                  size: 50,
                  artworkFit: BoxFit.fill,
                  quality: 100,
                  nullArtworkWidget: const Icon(
                    Icons.music_note_rounded,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  findSongs[index].displayNameWOExt,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  findSongs[index].artist!,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  GetSongs.audioPlayer.setAudioSource(
                      GetSongs.createSongList(findSongs),
                      initialIndex: index);
                  GetSongs.audioPlayer.play();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => NowPlaying(
                            audioPlayerSong: findSongs,
                          )),
                    ),
                  );
                },
              );
            }),
            itemCount: findSongs.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ))
        ]));
  }

  void runFilter(String keyword) {
    List<SongModel> results = [];
    if (keyword.isEmpty) {
      results = SongsList.song;
    } else {
      results = SongsList.song
          .where((SongModel item) => item.displayNameWOExt
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      findSongs = results;
    });
  }
}
