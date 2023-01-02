import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunin_2/db_functions/db_function/db_favourite.dart';
import 'package:tunin_2/screens/home_oage/home_page.dart';
import 'package:tunin_2/screens/favourite_pages/favourite_page.dart';
import 'package:tunin_2/screens/playlist_pages/playlist_page.dart';
import 'package:tunin_2/screens/settings_pages/settings_page.dart';
import 'package:tunin_2/widgets/colors.dart';
import 'package:tunin_2/widgets/get_songs.dart';
import 'package:tunin_2/widgets/miniplayer/mini_player.dart';

import 'package:tunin_2/screens/home_oage/now_playing_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<Widget> bottomNavOptions = <Widget>[
    const HomePage(),
    const FavoratePage(),
    const PlayListPage(),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: bottomNavOptions,
      ),
      backgroundColor: const Color.fromARGB(141, 0, 0, 0),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: playingSongNotifier,
        builder: (context, List<SongModel> music, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (GetSongs.audioPlayer.currentIndex != null)
                ValueListenableBuilder(
                    valueListenable: playingSongNotifier,
                    builder: (BuildContext context, playingSong, child) {
                      return Miniplayer(
                        minHeight: 70,
                        maxHeight: 70,
                        builder: (height, percentage) {
                          return MiniaudioPlayerWidget(
                            miniaudioPlayerSong: GetSongs.playingSongs,
                          );
                        },
                      );
                    }),
              const SizedBox.shrink(),
              
              GNav(
                  activeColor: ColorsinUse().red,
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      iconColor: Colors.white,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.favorite,
                      iconColor: Colors.white,
                      text: 'Favourites',
                    ),
                    GButton(
                      icon: Icons.playlist_add,
                      iconColor: Colors.white,
                      text: 'Playlists',
                    ),
                    GButton(
                      icon: Icons.settings,
                      iconColor: Colors.white,
                      text: 'Settings',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                      FavouriteDb.favouriteSongs.notifyListeners();
                      playingSongNotifier.notifyListeners();
                    });
                  }),
            ],
          );
        },
      ),
    );
  }
}
