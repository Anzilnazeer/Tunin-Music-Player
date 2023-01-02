import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tunin_2/db_functions/db_function/db_favourite.dart';
import 'package:tunin_2/screens/favourite_pages/favourite_button.dart';
import 'package:tunin_2/widgets/get_songs.dart';
import 'package:vibration/vibration.dart';

import '../../widgets/colors.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    Key? key,
    required this.audioPlayerSong,
  }) : super(key: key);

  final List<SongModel> audioPlayerSong;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

ValueNotifier<List<SongModel>> playingSongNotifier = ValueNotifier([]);

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  int currentIndex = 0;

  @override
  void initState() {
    GetSongs.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
        GetSongs.currentIndexes = index;
      }
    });

    super.initState();
    sliderFuntion();
  }

  void sliderFuntion() {
    GetSongs.audioPlayer.durationStream.listen((time) {
      setState(() {
        _duration = time!;
      });
    });
    GetSongs.audioPlayer.positionStream.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 140, 39, 39),
          Color.fromARGB(255, 98, 9, 9),
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 100,
          backgroundColor: const Color.fromARGB(30, 117, 2, 2),
          title: const Text(
            'Now Playing',
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
              GetSongs.audioPlayer.pause();
              FavouriteDb.favouriteSongs.notifyListeners();
            }),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 25,
            ),
          ),
        ),
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  height: 320,
                  width: 330,
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(78, 0, 0, 0),
                      blurRadius: 50,
                      spreadRadius: 5,
                      offset: Offset(-15, 45),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: SizedBox(
                  height: 320,
                  width: 330,
                  child: QueryArtworkWidget(
                      id: widget.audioPlayerSong[currentIndex].id,
                      type: ArtworkType.AUDIO,
                      keepOldArtwork: true,
                      artworkBorder: BorderRadius.circular(20),
                      artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                      artworkFit: BoxFit.fill,
                      quality: 100,
                      nullArtworkWidget: Lottie.asset(
                          "assets/lottie/30131-audio-power.json",
                          height: 100)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextScroll(
                  widget.audioPlayerSong[GetSongs.currentIndexes].title,
                  velocity: const Velocity(pixelsPerSecond: Offset(25, 0)),
                  style: const TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.audioPlayerSong[GetSongs.currentIndexes].artist
                              .toString() ==
                          '<Unknown>'
                      ? "Unknown Artist?"
                      : widget.audioPlayerSong[GetSongs.currentIndexes].artist
                          .toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FavouriteButton(
                  song: widget.audioPlayerSong[currentIndex],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Slider(
              thumbColor: const Color.fromARGB(79, 250, 245, 245),
              activeColor: const Color.fromARGB(255, 226, 226, 226),
              inactiveColor: const Color.fromARGB(85, 218, 218, 218),
              value: _position.inSeconds.toDouble(),
              min: const Duration(microseconds: 0).inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble(),
              onChanged: ((value) {
                setState(() {
                  changeToSeconds(value.toInt());
                  value = value;
                });
              })),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _position.toString().substring(2, 7).split('.')[0],
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  _duration.toString().substring(2, 7).split('.')[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  GetSongs.audioPlayer.shuffleModeEnabled
                      ? GetSongs.audioPlayer.setShuffleModeEnabled(false)
                      : GetSongs.audioPlayer.setShuffleModeEnabled(true);
                },
                icon: StreamBuilder(
                  stream: GetSongs.audioPlayer.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    if (GetSongs.audioPlayer.shuffleModeEnabled) {
                      return Icon(
                        Icons.shuffle,
                        color: ColorsinUse().white,
                        size: 25,
                      );
                    } else {
                      return const Icon(
                        Icons.shuffle,
                        size: 25,
                        color: Color.fromARGB(90, 255, 255, 255),
                      );
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (GetSongs.audioPlayer.hasPrevious) {
                      GetSongs.audioPlayer.seekToPrevious();
                      GetSongs.audioPlayer.play();
                    } else {
                      GetSongs.audioPlayer.play();
                    }
                  });
                },
                icon: const Icon(
                  Icons.skip_previous_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                iconSize: 50,
                icon: StreamBuilder(
                    stream: GetSongs.audioPlayer.playingStream,
                    builder: (context, snapshot) {
                      bool? playing = snapshot.data;
                      if (playing != null && playing) {
                        return const Icon(
                          Icons.pause,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 45,
                        );
                      } else {
                        return const Icon(
                          Icons.play_arrow,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 45,
                        );
                      }
                    }),
                onPressed: (() async {
                  if (GetSongs.audioPlayer.playing) {
                    await GetSongs.audioPlayer.pause();
                    setState(() {});
                  } else {
                    await GetSongs.audioPlayer.play();
                    setState(() {});
                  }
                }),
              ),
              IconButton(
                onPressed: () {
                  setState(() async {
                    if (GetSongs.audioPlayer.hasNext) {
                      await GetSongs.audioPlayer.seekToNext();
                      await GetSongs.audioPlayer.play();
                    } else {
                      await GetSongs.audioPlayer.play();
                    }
                  });
                },
                icon: const Icon(
                  Icons.skip_next_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: (() {
                  GetSongs.audioPlayer.loopMode == LoopMode.one
                      ? GetSongs.audioPlayer.setLoopMode(LoopMode.all)
                      : GetSongs.audioPlayer.setLoopMode(LoopMode.one);
                }),
                icon: StreamBuilder<LoopMode>(
                  stream: GetSongs.audioPlayer.loopModeStream,
                  builder: (context, item) {
                    final loopMode = item.data;
                    if (LoopMode.one == loopMode) {
                      return const Icon(
                        Icons.repeat,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 25,
                      );
                    } else {
                      return const Icon(
                        Icons.repeat,
                        size: 25,
                        color: Color.fromARGB(90, 255, 255, 255),
                      );
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void changeToSeconds(int secoonds) {
    Duration duration = Duration(seconds: secoonds);
    GetSongs.audioPlayer.seek(duration);
  }
}
