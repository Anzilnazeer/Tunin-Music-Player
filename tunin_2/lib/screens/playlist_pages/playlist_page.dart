import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tunin_2/db_functions/model/audio_player.dart';
import 'package:tunin_2/screens/playlist_pages/playlist_add_song.dart';
import 'package:tunin_2/screens/playlist_pages/dialog_list.dart';
import 'package:tunin_2/screens/settings_pages/settings_option.dart';

import '../../widgets/colors.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController newPlaylistController = TextEditingController();

class _PlayListPageState extends State<PlayListPage> {
  late final AudioPlayer playlist;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<AudioPlayer>('playlistDB').listenable(),
      builder: (context, Box<AudioPlayer> musicList, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Center(
              child: Text(
                'Playlists',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              OptionWidget(
                infoText: 'Add playlist',
                infoIcon: Icons.playlist_add,
                infoAction: () {
                  DialogList.addPlaylistDialog(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Hive.box<AudioPlayer>('playlistDB').isEmpty
                  ? const Center(
                      child: Text(
                        'No playlists added',
                        style:
                            TextStyle(color: Color.fromARGB(255, 75, 75, 75)),
                      ),
                    )
                  : ValueListenableBuilder(
                      valueListenable:
                          Hive.box<AudioPlayer>('playlistDB').listenable(),
                      builder: (BuildContext context,
                          Box<AudioPlayer> musicList, Widget? child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: musicList.length,
                          itemBuilder: ((context, index) {
                            final data = musicList.values.toList()[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, top: 15),
                              child: ListTile(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                ),
                                tileColor:
                                    const Color.fromARGB(57, 129, 129, 129),
                                leading: const Icon(
                                  Icons.folder,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  data.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorsinUse().red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    206, 69, 69, 69),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            title: const Text(
                                              'Delete Playlist',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 15),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this playlist?',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 227, 66, 66),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  musicList.deleteAt(index);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return PlaylistAddSongs(
                                        playlist: data,
                                        folderindex: index,
                                      );
                                    },
                                  ));
                                },
                              ),
                            );
                          }),
                        );
                      },
                    ),
            ]),
          ),
        );
      },
    );
  }
}
