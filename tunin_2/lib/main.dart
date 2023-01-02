import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:tunin_2/db_functions/model/audio_player.dart';
import 'package:tunin_2/splash_screen.dart';

Future<void> main(context) async {
 
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AudioPlayerAdapter().typeId)) {
    Hive.registerAdapter(AudioPlayerAdapter());
  }
  await Hive.openBox<int>('favouriteDB');
  await Hive.openBox<AudioPlayer>('playlistDB');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.from(colorScheme: const ColorScheme.dark()),
      home: const SplashScreen(),
    );
  }
}
