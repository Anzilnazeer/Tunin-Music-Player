import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../db_functions/db_function/db_favourite.dart';
import '../../widgets/colors.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({required this.song, super.key});
  final SongModel song;
  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavouriteDb.favouriteSongs,
        builder:
            (BuildContext context, List<SongModel> favourData, Widget? child) {
          return IconButton(
            onPressed: (() {
              if (FavouriteDb.favourCheck(widget.song)) {
                FavouriteDb.delete(widget.song.id);
                FavouriteDb.favouriteSongs.notifyListeners();

                final snackBar = SnackBar(
                    backgroundColor: const Color.fromARGB(126, 0, 0, 0),
                    duration: const Duration(milliseconds: 800),
                    behavior: SnackBarBehavior.floating,
                    width: 200,
                    content: Text(
                      'Removed From Favourites',
                      style: TextStyle(
                        color: ColorsinUse().white,
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                FavouriteDb.add(widget.song);
                FavouriteDb.favouriteSongs.notifyListeners();

                final snackBar = SnackBar(
                    backgroundColor: const Color.fromARGB(126, 0, 0, 0),
                    duration: const Duration(milliseconds: 800),
                    behavior: SnackBarBehavior.floating,
                    width: 200,
                    content: Text(
                      'Added to Favourites',
                      style: TextStyle(
                        color: ColorsinUse().white,
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              FavouriteDb.favouriteSongs.notifyListeners();
            }),
            icon: FavouriteDb.favourCheck(widget.song)
                ? Icon(
                    Icons.favorite,
                    color: ColorsinUse().red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Color.fromARGB(255, 151, 151, 151),
                  ),
          );
        });
  }
}
