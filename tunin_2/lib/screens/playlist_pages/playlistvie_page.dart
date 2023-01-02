import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunin_2/db_functions/db_function/db_playlist.dart';

import '../../db_functions/model/audio_player.dart';
import '../../widgets/colors.dart';

class PlaylistViewPage extends StatefulWidget {
  const PlaylistViewPage({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final AudioPlayer playlist;
  @override
  State<PlaylistViewPage> createState() => _PlaylistViewPageState();
}

class _PlaylistViewPageState extends State<PlaylistViewPage> {
  final audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add songs'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<SongModel>>(
          future: audioQuery.querySongs(
            sortType: SongSortType.TITLE,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No Songs Found',
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: ((ctx, index) {
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
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
                    item.data![index].displayNameWOExt,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${item.data![index].artist}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                      onPressed: (() {
                        setState(() {
                          checkPlaylist(item.data![index]);

                          PlaylistDb.playlistNotifier.notifyListeners();
                        });
                      }),
                      icon: !widget.playlist.isValueIn(item.data![index].id)
                          ? const Icon(
                              Icons.add,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.remove,
                              color: ColorsinUse().red,
                            )),
                );
              }),
              itemCount: item.data!.length,
            );
          },
        ),
      ),
    );
  }

  void checkPlaylist(SongModel data) {
    if (!widget.playlist.isValueIn(data.id)) {
      widget.playlist.add(data.id);
      final snackbar = SnackBar(
          backgroundColor: const Color.fromARGB(126, 0, 0, 0),
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
          width: 200,
          content: Text(
            'Added to Playlist',
            style: TextStyle(
              color: ColorsinUse().white,
            ),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      widget.playlist.deleteData(data.id);
      final snackbar = SnackBar(
        backgroundColor: const Color.fromARGB(126, 0, 0, 0),
        content: Text(
          'Song Deleted',
          style: TextStyle(
            color: ColorsinUse().white,
          ),
        ),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        width: 200,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
