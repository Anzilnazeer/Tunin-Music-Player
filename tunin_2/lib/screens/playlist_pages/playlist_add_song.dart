import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunin_2/db_functions/db_function/db_playlist.dart';
import 'package:tunin_2/db_functions/model/audio_player.dart';
import 'package:tunin_2/screens/playlist_pages/playlistvie_page.dart';
import '../../widgets/colors.dart';
import '../../widgets/get_songs.dart';
import '../home_oage/now_playing_page.dart';
import '../favourite_pages/favourite_button.dart';

class PlaylistAddSongs extends StatefulWidget {
  const PlaylistAddSongs(
      {Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final AudioPlayer playlist;
  final int folderindex;

  @override
  State<PlaylistAddSongs> createState() => _PlaylistAddSongsState();
}

class _PlaylistAddSongsState extends State<PlaylistAddSongs> {
  late List<SongModel> playlistSong;
  @override
  Widget build(BuildContext context) {
    PlaylistDb.getAllPlaylist();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 1, 1),
      appBar: AppBar(
        title: Text(widget.playlist.name),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PlaylistViewPage(playlist: widget.playlist),
                ));
              },
              icon: const Icon(
                Icons.playlist_add,
                size: 30,
              ))
        ],
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: Hive.box<AudioPlayer>('playlistDB').listenable(),
        builder: (BuildContext context, Box<AudioPlayer> value, Widget? child) {
          playlistSong =
              listplaylist(value.values.toList()[widget.folderindex].songId);
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: ((context, index) {
              return Slidable(
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    flex: 1,
                    onPressed: (context) {
                      widget.playlist.deleteData(playlistSong[index].id);
                    },
                    backgroundColor: ColorsinUse().red,
                    foregroundColor: ColorsinUse().white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ]),
                child: ListTile(
                    onTap: () async {
                      List<SongModel> newList = [...playlistSong];
                      GetSongs.audioPlayer.setAudioSource(
                          GetSongs.createSongList(newList),
                          initialIndex: index);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => NowPlaying(
                                audioPlayerSong: playlistSong,
                              )),
                        ),
                      );
                      GetSongs.audioPlayer.play();
                    },
                    leading: QueryArtworkWidget(
                      id: playlistSong[index].id,
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
                      playlistSong[index].displayNameWOExt,
                      maxLines: 1,
                      style: TextStyle(color: ColorsinUse().white),
                    ),
                    subtitle: Text(
                      playlistSong[index].artist!,
                      style: TextStyle(color: ColorsinUse().white),
                    ),
                    trailing: FavouriteButton(
                      song: playlistSong[index],
                    )),
              );
            }),
            itemCount: playlistSong.length,
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      )),
    );
  }

  List<SongModel> listplaylist(List<int> data) {
    List<SongModel> playsongs = [];
    for (int i = 0; i < GetSongs.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songscopy[i].id == data[j]) {
          playsongs.add(GetSongs.songscopy[i]);
        }
      }
    }
    return playsongs;
  }
}
