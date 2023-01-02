import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tunin_2/screens/home_oage/now_playing_page.dart';

import '../get_songs.dart';

class MiniaudioPlayerWidget extends StatefulWidget {
  const MiniaudioPlayerWidget({
    super.key,
    required this.miniaudioPlayerSong,
  });
  final List<SongModel> miniaudioPlayerSong;

  @override
  State<MiniaudioPlayerWidget> createState() => _MiniaudioPlayerWidgetState();
}

class _MiniaudioPlayerWidgetState extends State<MiniaudioPlayerWidget> {
  @override
  void initState() {
    GetSongs.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {});
        GetSongs.currentIndexes = index;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 140, 39, 39),
              Color.fromARGB(255, 98, 9, 9),
            ],
          )),
      child: Center(
        child: ListTile(
          leading: QueryArtworkWidget(
              artworkFit: BoxFit.fill,
              artworkBorder: BorderRadius.circular(5),
              id: widget.miniaudioPlayerSong[GetSongs.currentIndexes].id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: const Icon(
                Icons.music_note,
                color: Colors.white,
              )),
          onTap: () {
            Navigator.of(context).push(createRoute());
            GetSongs.audioPlayer.play();
          },
          title: TextScroll(
            GetSongs.playingSongs[GetSongs.currentIndexes].title,
            velocity: const Velocity(pixelsPerSecond: Offset(25, 0)),
            style: const TextStyle(
              fontSize: 15,
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: FittedBox(
            fit: BoxFit.fill,
            child: Row(
              children: [
                IconButton(
                    onPressed: () async {
                      if (GetSongs.audioPlayer.playing) {
                        await GetSongs.audioPlayer.pause();
                        setState(() {});
                      } else {
                        await GetSongs.audioPlayer.play();
                        setState(() {});
                      }
                    },
                    icon: StreamBuilder<bool>(
                      stream: GetSongs.audioPlayer.playingStream,
                      builder: (context, snapshot) {
                        bool? playingStage = snapshot.data;
                        if (playingStage != null && playingStage) {
                          return const Icon(
                            Icons.pause,
                            size: 33,
                            color: Color.fromARGB(255, 255, 255, 255),
                          );
                        } else {
                          return const Icon(
                            Icons.play_arrow,
                            size: 35,
                            color: Color.fromARGB(255, 255, 255, 255),
                          );
                        }
                      },
                    )),
                IconButton(
                    onPressed: () async {
                      if (GetSongs.audioPlayer.hasNext) {
                        await GetSongs.audioPlayer.seekToNext();
                        await GetSongs.audioPlayer.play();
                      } else {
                        await GetSongs.audioPlayer.play();
                      }
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      size: 35,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          NowPlaying(audioPlayerSong: widget.miniaudioPlayerSong),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
