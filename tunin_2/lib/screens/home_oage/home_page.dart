import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:tunin_2/screens/home_oage/search_song.dart';

import 'package:tunin_2/screens/home_oage/songs_list.dart';

import '../../widgets/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text("TUNIN"),
        actions: [
          IconButton(
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Serach()));
                });
              },
              icon: Icon(Icons.search, color: ColorsinUse().white))
        ],
        backgroundColor: Colors.black,
      ),
      body: FadeScrollAppBar(
        scrollController: _scrollController,
        pinned: false,
        fadeOffset: 120,
        expandedHeight: 150,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        fadeWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Hello Listener !",
                    style: TextStyle(
                      color: ColorsinUse().red,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    "Hear what you like ",
                    style: TextStyle(
                      color: ColorsinUse().white,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        child: const SongsList(),
      ),
    );
  }
}
