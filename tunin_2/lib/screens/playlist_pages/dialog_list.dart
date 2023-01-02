import 'package:flutter/material.dart';

import '../../db_functions/db_function/db_playlist.dart';
import '../../db_functions/model/audio_player.dart';
import '../../widgets/colors.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController newPlaylistController = TextEditingController();

class DialogList {
  // dialog for Adding playlist
  static addPlaylistDialog(context) {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(206, 69, 69, 69),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Create new playlist',
            style: TextStyle(color: ColorsinUse().white, fontSize: 15),
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              cursorColor: ColorsinUse().red,
              style: TextStyle(color: ColorsinUse().white),
              controller: newPlaylistController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorsinUse().red,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 63, 39, 39))),
                label: const Text(
                  'Playlist Name',
                  style: TextStyle(
                    color: Color.fromARGB(255, 176, 176, 176),
                    fontSize: 12,
                  ),
                ),
              ),
              validator: (value) {
                bool check = PlaylistDb().playlistnameCheck(value);
                if (value == '') {
                  return 'Enter playlist name';
                } else if (check) {
                  return '$value already exist';
                } else {
                  return null;
                }
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: (() {
                  return Navigator.of(context).pop();
                }),
                child: Text(
                  'cancel',
                  style: TextStyle(color: ColorsinUse().white),
                )),
            TextButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = newPlaylistController.text.trimLeft();
                    if (name.isEmpty) {
                      return;
                    } else {
                      final music = AudioPlayer(name: name, songId: []);

                      PlaylistDb.playlistAdd(music);
                      newPlaylistController.clear();
                    }
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(
                  Icons.playlist_add,
                  color: ColorsinUse().red,
                ),
                label: Text(
                  'create',
                  style: TextStyle(
                    color: ColorsinUse().red,
                  ),
                )),
          ],
        );
      }),
    );
  }
}
